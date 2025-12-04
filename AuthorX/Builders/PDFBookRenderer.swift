//
//  PDFBookRenderer.swift
//  AuthorX
//
//  Created by Manh Nguyen on 11/27/25.
//

import UIKit
import PDFKit
import CoreText

final class PDFBookRenderer {

    struct Layout {
        let pageSize = CGSize(width: 612, height: 792)   // US Letter
        let margin: CGFloat = 40
        let titleHeight: CGFloat = 40
        let imageHeight: CGFloat = 220
        let spacing: CGFloat = 16
    }

    private let layout = Layout()

    func generatePDF(bookDetail: BookDetail) throws -> Data {

        let renderer = UIGraphicsPDFRenderer(
            bounds: CGRect(origin: .zero, size: layout.pageSize)
        )

        let data = renderer.pdfData { context in

            // ✅ Cover Page
            renderCoverPage(context: context, bookDetail: bookDetail)

            // ✅ Chapter Pages
            for chapter in bookDetail.chapters {
                context.beginPage()
                renderChapterPage(context: context, bookDetail: bookDetail, chapter: chapter)
            }
        }

        return data
    }
}

private extension PDFBookRenderer {
    
    func renderChapterWithPagination(
            context: UIGraphicsPDFRendererContext,
            chapter: Chapter
        ) {
        let titleFont = UIFont.boldSystemFont(ofSize: 22)
        let bodyFont = UIFont.systemFont(ofSize: 14)

        var remainingText = chapter.content
        var isFirstPage = true

        while !remainingText.isEmpty {

            context.beginPage()

            var currentY: CGFloat = layout.margin

            // ✅ Draw title only on first page
            if isFirstPage {
                let titleRect = CGRect(
                    x: layout.margin,
                    y: currentY,
                    width: layout.pageSize.width - 2 * layout.margin,
                    height: layout.titleHeight
                )

                "Chapter \(chapter.chapterOrder)"
                    .draw(in: titleRect, withAttributes: [
                        .font: titleFont
                    ])

                currentY += layout.titleHeight + layout.spacing
            }

            // ✅ Draw image only on first page
            if isFirstPage,
               let imageUrl = URL(string: chapter.chapterImageUrl),
               let data = try? Data(contentsOf: imageUrl),
               let image = UIImage(data: data) {

                let imageRect = CGRect(
                    x: layout.margin,
                    y: currentY,
                    width: layout.pageSize.width - 2 * layout.margin,
                    height: layout.imageHeight
                )

                image.draw(in: imageRect)
                currentY += layout.imageHeight + layout.spacing
            }

            let textRect = CGRect(
                x: layout.margin,
                y: currentY,
                width: layout.pageSize.width - 2 * layout.margin,
                height: layout.pageSize.height - currentY - layout.margin
            )

            // Render as much text as fits
            let (remaining, didFillPage) = drawText(
                remainingText,
                in: textRect,
                font: bodyFont
            )

            remainingText = remaining
            isFirstPage = false

            if !didFillPage {
                break
            }
        }
    }
    
    private func drawText(
        _ text: String,
        in rect: CGRect,
        font: UIFont
    ) -> (remainingText: String, didFillPage: Bool) {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle
        ]

        let attributed = NSAttributedString(string: text, attributes: attributes)

        let framesetter = CTFramesetterCreateWithAttributedString(attributed)

        let path = CGPath(rect: rect, transform: nil)

        let frame = CTFramesetterCreateFrame(
            framesetter,
            CFRange(location: 0, length: 0),
            path,
            nil
        )

        CTFrameDraw(frame, UIGraphicsGetCurrentContext()!)

        // Find how much text fit
        let visibleRange = CTFrameGetVisibleStringRange(frame)

        if visibleRange.length == attributed.length {
            return ("", false)
        }

        let remaining = attributed.attributedSubstring(
            from: NSRange(
                location: visibleRange.length,
                length: attributed.length - visibleRange.length
            )
        ).string

        return (remaining, true)
    }

    func renderCoverPage(
        context: UIGraphicsPDFRendererContext,
        bookDetail: BookDetail
    ) {
        context.beginPage()

        let titleFont = UIFont.boldSystemFont(ofSize: 34)
        let subtitleFont = UIFont.systemFont(ofSize: 16)

        let titleAttrs: [NSAttributedString.Key: Any] = [
            .font: titleFont
        ]

        let subtitleAttrs: [NSAttributedString.Key: Any] = [
            .font: subtitleFont
        ]

        let titleRect = CGRect(
            x: layout.margin,
            y: 80,
            width: layout.pageSize.width - 2 * layout.margin,
            height: 100
        )

        bookDetail.book.title.draw(
            in: titleRect,
            withAttributes: titleAttrs
        )

        let authorText = "by \(bookDetail.book.author.name)"
        authorText.draw(
            in: titleRect.offsetBy(dx: 0, dy: 100),
            withAttributes: subtitleAttrs
        )

        // ✅ Cover Image
        if let imageUrl = URL(string: bookDetail.book.coverImageUrl),
           let imageData = try? Data(contentsOf: imageUrl),
           let coverImage = UIImage(data: imageData) {

            let imageRect = CGRect(
                x: layout.margin,
                y: 260,
                width: layout.pageSize.width - 2 * layout.margin,
                height: 360
            )

            coverImage.draw(in: imageRect)
        }
    }
}

private extension PDFBookRenderer {

    func renderChapterPage(
        context: UIGraphicsPDFRendererContext,
        bookDetail: BookDetail,
        chapter: Chapter
    ) {
        let titleFont = UIFont.boldSystemFont(ofSize: 22)
        let bodyFont = UIFont.systemFont(ofSize: 14)

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: titleFont
        ]

        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont
        ]

        var currentY: CGFloat = layout.margin

        // ✅ Chapter Title
        let titleRect = CGRect(
            x: layout.margin,
            y: currentY,
            width: layout.pageSize.width - 2 * layout.margin,
            height: layout.titleHeight
        )

        "Chapter \(chapter.chapterOrder)"
            .draw(in: titleRect, withAttributes: titleAttributes)

        currentY += layout.titleHeight + layout.spacing

        // ✅ Chapter Image
        if let imageUrl = URL(string: chapter.chapterImageUrl),
           let data = try? Data(contentsOf: imageUrl),
           let image = UIImage(data: data) {

            let imageRect = CGRect(
                x: layout.margin,
                y: currentY,
                width: layout.pageSize.width - 2 * layout.margin,
                height: layout.imageHeight
            )

            image.draw(in: imageRect)
            currentY += layout.imageHeight + layout.spacing
        }

        // ✅ Chapter Content
        let contentRect = CGRect(
            x: layout.margin,
            y: currentY,
            width: layout.pageSize.width - 2 * layout.margin,
            height: layout.pageSize.height - currentY - layout.margin
        )

        let attributed = NSAttributedString(
            string: chapter.content,
            attributes: bodyAttributes
        )

        attributed.draw(in: contentRect)
    }
}
