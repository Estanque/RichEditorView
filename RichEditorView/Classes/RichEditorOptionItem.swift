//
//  RichEditorOptionItem.swift
//
//  Created by Caesar Wirth on 4/2/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import UIKit

/**
    A RichEditorOption object is an object that can be displayed in a RichEditorToolbar.
    This protocol is proviced to allow for custom actions not provided in the RichEditorOptions enum
*/
public protocol RichEditorOption {

    /**
        Returns the image to be displayed in the RichEditorToolbar
    */
    func image() -> UIImage?

    /**
        Returns the title of the item.
        If `image()` returns nil, this method will be used for display in the RichEditorToolbar
    */
    func title() -> String

    /**
        The action to be evoked when the action is tapped
    
        - parameter editor: The RichEditorToolbar that the RichEditorOption was being displayed in when tapped.
                       Contains a reference to the `editor` RichEditorView to perform actions on
    */
    func action(toolbar: RichEditorToolbar?)
}

/**
    RichEditorOptionItem is a concrete implementation of RichEditorOption
    It can be used as a configuration object for custom objects to be shown on a RichEditorToolbar
*/
public struct RichEditorOptionItem: RichEditorOption {

    /**
        The image that should be shown when displayed in the RichEditorToolbar
    */
    public var itemImage: UIImage?

    /**
        If an `itemImage` is not specified, this is used in display
    */
    public var itemTitle: String

    /**
        The action to be performed when tapped
    */
    public var itemAction: ((RichEditorToolbar?) -> Void)

    public init(image: UIImage?, title: String, action: @escaping ((RichEditorToolbar?) -> Void)) {
        itemImage = image
        itemTitle = title
        itemAction = action
    }
    
    // MARK: RichEditorOption
    
    public func image() -> UIImage? {
        return itemImage
    }
    
    public func title() -> String {
        return itemTitle
    }
    
    
    public func action(toolbar: RichEditorToolbar?) {
        itemAction(toolbar)
    }
}

/**
    RichEditorOptions is an enum of standard editor actions
*/
public enum RichEditorOptions: RichEditorOption {

    case keyboard
    case clear
    case undo
    case redo
    case bold
    case italic
    case `subscript`
    case superscript
    case strike
    case underline
    case textColor
    case textBackgroundColor
    case font
    case fontSize
    case header(Int)
    case indent
    case outdent
    case orderedList
    case unorderedList
    case alignLeft
    case alignCenter
    case alignRight
    case Image
    case link
    case quickLink
    
    public static func all() -> [RichEditorOption] {
        return [
            keyboard,
            clear,
            undo, redo, bold, italic,
            `subscript`, superscript, strike, underline,
            font, fontSize,
            textColor, textBackgroundColor,
            header(1), header(2), header(3), header(4), header(5), header(6),
            indent, outdent, orderedList, unorderedList,
            alignLeft, alignCenter, alignRight, Image, link, quickLink
        ]
    }
    
    // MARK: RichEditorOption
    
    public func image() -> UIImage? {
        var name = ""
        switch self {
        case .keyboard: name = "keyboard"
        case .clear: name = "clear"
        case .undo: name = "undo"
        case .redo: name = "redo"
        case .bold: name = "bold"
        case .italic: name = "italic"
        case .subscript: name = "subscript"
        case .superscript: name = "superscript"
        case .strike: name = "strikethrough"
        case .underline: name = "underline"
        case .font: name = "font"
        case .fontSize: name = "font_size"
        case .textColor: name = "text_color"
        case .textBackgroundColor: name = "bg_color"
        case .header(let h): name = "h\(h)"
        case .indent: name = "indent"
        case .outdent: name = "outdent"
        case .orderedList: name = "ordered_list"
        case .unorderedList: name = "unordered_list"
        case .alignLeft: name = "justify_left"
        case .alignCenter: name = "justify_center"
        case .alignRight: name = "justify_right"
        case .Image: name = "insert_image"
        case .link: name = "insert_link"
        case .quickLink: name = "quick_link"
        }
        
        let bundle = Bundle(for: RichEditorToolbar.self)
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    public func title() -> String {
        switch self {
        case .keyboard: return NSLocalizedString("Hide keyboard", comment: "")
        case .clear: return NSLocalizedString("Clear", comment: "")
        case .undo: return NSLocalizedString("Undo", comment: "")
        case .redo: return NSLocalizedString("Redo", comment: "")
        case .bold: return NSLocalizedString("Bold", comment: "")
        case .italic: return NSLocalizedString("Italic", comment: "")
        case .subscript: return NSLocalizedString("Sub", comment: "")
        case .superscript: return NSLocalizedString("Super", comment: "")
        case .strike: return NSLocalizedString("Strike", comment: "")
        case .underline: return NSLocalizedString("Underline", comment: "")
        case .font: return NSLocalizedString("Font", comment: "")
        case .fontSize: return NSLocalizedString("Font Size", comment: "")
        case .textColor: return NSLocalizedString("Color", comment: "")
        case .textBackgroundColor: return NSLocalizedString("BG Color", comment: "")
        case .header(let h): return NSLocalizedString("H\(h)", comment: "")
        case .indent: return NSLocalizedString("Indent", comment: "")
        case .outdent: return NSLocalizedString("Outdent", comment: "")
        case .orderedList: return NSLocalizedString("Ordered List", comment: "")
        case .unorderedList: return NSLocalizedString("Unordered List", comment: "")
        case .alignLeft: return NSLocalizedString("Left", comment: "")
        case .alignCenter: return NSLocalizedString("Center", comment: "")
        case .alignRight: return NSLocalizedString("Right", comment: "")
        case .Image: return NSLocalizedString("Image", comment: "")
        case .link: return NSLocalizedString("Link", comment: "")
        case .quickLink: return NSLocalizedString("QuickLink", comment: "")
        }
    }
    
    public func action(toolbar: RichEditorToolbar?) {
        if let toolbar = toolbar {
            switch self {
            case .keyboard: toolbar.editor?.blur()
            case .clear: toolbar.editor?.removeFormat()
            case .undo: toolbar.editor?.undo()
            case .redo: toolbar.editor?.redo()
            case .bold: toolbar.editor?.bold()
            case .italic: toolbar.editor?.italic()
            case .subscript: toolbar.editor?.subscriptText()
            case .superscript: toolbar.editor?.superscript()
            case .strike: toolbar.editor?.strikethrough()
            case .underline: toolbar.editor?.underline()
            case .font: toolbar.delegate?.richEditorToolbarChangeFont?(toolbar: toolbar)
            case .fontSize: toolbar.delegate?.richEditorToolbarChangeFontSize?(toolbar: toolbar)
            case .textColor: toolbar.delegate?.richEditorToolbarChangeTextColor?(toolbar: toolbar)
            case .textBackgroundColor: toolbar.delegate?.richEditorToolbarChangeBackgroundColor?(toolbar: toolbar)
            case .header(let h): toolbar.editor?.header(h: h)
            case .indent: toolbar.editor?.indent()
            case .outdent: toolbar.editor?.outdent()
            case .orderedList: toolbar.editor?.orderedList()
            case .unorderedList: toolbar.editor?.unorderedList()
            case .alignLeft: toolbar.editor?.alignLeft()
            case .alignCenter: toolbar.editor?.alignCenter()
            case .alignRight: toolbar.editor?.alignRight()
            case .Image: toolbar.delegate?.richEditorToolbarInsertImage?(toolbar: toolbar)
            case .link: toolbar.delegate?.richEditorToolbarInsertLink?(toolbar: toolbar)
            case .quickLink: toolbar.editor?.quickLink()
            }
        }
    }
}
