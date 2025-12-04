//
//  EPUBBuilder.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/26/25.
//

import Foundation
import ZIPFoundation

struct EPUBBuilder {
    
    func buildEPUB(from bookDetail: BookDetail, to destinationURL: URL) throws {
        let fm = FileManager.default
        let workDir = FileManager.exportDirectory
            .appendingPathComponent("epub_\(UUID().uuidString)", isDirectory: true)
        
        try fm.createDirectory(at: workDir, withIntermediateDirectories: true)
        
        // Paths
        let metaInfDir = workDir.appendingPathComponent("META-INF", isDirectory: true)
        let oebpsDir   = workDir.appendingPathComponent("OEBPS", isDirectory: true)
        
        try fm.createDirectory(at: metaInfDir, withIntermediateDirectories: true)
        try fm.createDirectory(at: oebpsDir,   withIntermediateDirectories: true)
        
        // 1. mimetype (must be plain text, uncompressed in the final zip)
        let mimetypeURL = workDir.appendingPathComponent("mimetype")
        try "application/epub+zip".write(to: mimetypeURL, atomically: true, encoding: .utf8)
        
        // 2. container.xml
        let containerXML = """
        <?xml version="1.0" encoding="UTF-8"?>
        <container version="1.0"
                   xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
          <rootfiles>
            <rootfile full-path="OEBPS/content.opf"
                      media-type="application/oebps-package+xml"/>
          </rootfiles>
        </container>
        """
        try containerXML.write(
            to: metaInfDir.appendingPathComponent("container.xml"),
            atomically: true,
            encoding: .utf8
        )
        
        // 3. stylesheet.css (very simple)
        let css = """
        body { font-family: -apple-system, system-ui, sans-serif; line-height: 1.4; }
        h1   { font-size: 1.6em; margin-bottom: 0.4em; }
        p    { margin: 0.4em 0; }
        """
        try css.write(
            to: oebpsDir.appendingPathComponent("stylesheet.css"),
            atomically: true,
            encoding: .utf8
        )
        
        // 4. chapter XHTML files
        var itemRefs: [String] = []
        var manifestItems: [String] = []
        var spineItems: [String] = []
        
        for (index, chapter) in bookDetail.chapters.enumerated() {
            let id = "chapter\(index + 1)"
            let filename = "\(id).xhtml"
            let fileURL = oebpsDir.appendingPathComponent(filename)
            
            let xhtml = xhtmlForChapter(
                title: "Chapter \(index + 1)",
                content: chapter.content
            )
            try xhtml.write(to: fileURL, atomically: true, encoding: .utf8)
            
            manifestItems.append("""
              <item id="\(id)"
                    href="\(filename)"
                    media-type="application/xhtml+xml"/>
            """)
            spineItems.append(#"<itemref idref="\#(id)"/>"#)
            itemRefs.append(filename)
        }
        
        // 5. nav.xhtml (EPUB 3 navigation)
        let nav = navXHTML(
            bookTitle: bookDetail.book.title,
            chapters: itemRefs
        )
        let navURL = oebpsDir.appendingPathComponent("nav.xhtml")
        try nav.write(to: navURL, atomically: true, encoding: .utf8)
        
        manifestItems.append("""
          <item id="nav"
                href="nav.xhtml"
                media-type="application/xhtml+xml"
                properties="nav"/>
        """)
        
        // 6. content.opf (package file)
        let opf = contentOPF(
            bookDetail: bookDetail,
            manifestItems: manifestItems.joined(separator: "\n"),
            spineItems: spineItems.joined(separator: "\n")
        )
        try opf.write(
            to: oebpsDir.appendingPathComponent("content.opf"),
            atomically: true,
            encoding: .utf8
        )
        
        // 7. Zip everything into .epub
        if fm.fileExists(atPath: destinationURL.path) {
            try fm.removeItem(at: destinationURL)
        }
        
        guard let archive = Archive(url: destinationURL, accessMode: .create) else {
            throw ExportError.epubGenerationFailed
        }
        
        // a) mimetype FIRST + uncompressed
        try archive.addEntry(
            with: "mimetype",
            fileURL: mimetypeURL,
            compressionMethod: .none
        )
        
        // b) everything else (directories + files)
        try fm.enumerator(at: workDir, includingPropertiesForKeys: nil)?
            .forEach { item in
                guard let fileURL = item as? URL else { return }
                let path = fileURL.path.replacingOccurrences(of: workDir.path + "/", with: "")
                guard path != "mimetype" else { return }
                
                if fileURL.hasDirectoryPath { return }
                
                try archive.addEntry(
                    with: path,
                    fileURL: fileURL,
                    compressionMethod: .deflate
                )
            }
        
        // Optional: clean temp dir
        try? fm.removeItem(at: workDir)
    }
    
    // MARK: - Helpers
    
    private func xhtmlForChapter(title: String, content: String) -> String {
        let escaped = content
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
        
        return """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE html>
        <html xmlns="http://www.w3.org/1999/xhtml">
          <head>
            <title>\(title)</title>
            <link href="stylesheet.css" rel="stylesheet" type="text/css"/>
          </head>
          <body>
            <h1>\(title)</h1>
            <p>\(escaped.replacingOccurrences(of: "\n", with: "</p><p>"))</p>
          </body>
        </html>
        """
    }
    
    private func navXHTML(bookTitle: String, chapters: [String]) -> String {
        let items = chapters.enumerated().map { index, href in
            """
            <li><a href="\(href)">Chapter \(index + 1)</a></li>
            """
        }.joined(separator: "\n")
        
        return """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE html>
        <html xmlns="http://www.w3.org/1999/xhtml"
              xmlns:epub="http://www.idpf.org/2007/ops">
          <head>
            <title>\(bookTitle)</title>
            <link href="stylesheet.css" rel="stylesheet" type="text/css"/>
          </head>
          <body>
            <nav epub:type="toc" id="toc">
              <h1>Contents</h1>
              <ol>
                \(items)
              </ol>
            </nav>
          </body>
        </html>
        """
    }
    
    private func contentOPF(
        bookDetail: BookDetail,
        manifestItems: String,
        spineItems: String
    ) -> String {
        let book = bookDetail.book
        let authorName = book.author.name
        
        return """
        <?xml version="1.0" encoding="UTF-8"?>
        <package version="3.0"
                 unique-identifier="bookid"
                 xmlns="http://www.idpf.org/2007/opf">
          <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
            <dc:identifier id="bookid">\(book.id)</dc:identifier>
            <dc:title>\(book.title)</dc:title>
            <dc:creator>\(authorName)</dc:creator>
            <dc:language>en</dc:language>
          </metadata>
          <manifest>
            <item id="css" href="stylesheet.css" media-type="text/css"/>
        \(manifestItems)
          </manifest>
          <spine>
        \(spineItems)
          </spine>
        </package>
        """
    }
}
