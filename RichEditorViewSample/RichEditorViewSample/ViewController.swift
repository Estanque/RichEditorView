//
//  ViewController.swift
//  RichEditorViewSample
//
//  Created by Caesar Wirth on 4/5/15.
//  Copyright (c) 2015 Caesar Wirth. All rights reserved.
//

import UIKit
import RichEditorView

class ViewController: UIViewController {

    @IBOutlet var editorView: RichEditorView!
    @IBOutlet var htmlTextView: UITextView!

    lazy var toolbar: RichEditorToolbar = {
        let toolbar = RichEditorToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.options = RichEditorOptions.all()
        return toolbar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        editorView.delegate = self
        editorView.inputAccessoryView = toolbar

        toolbar.delegate = self
        toolbar.editor = editorView

        // We will create a custom action that clears all the input text when it is pressed
        let item = RichEditorOptionItem(image: nil, title: "Clear") { toolbar in
            toolbar?.editor?.setHTML("")
        }
        
        var html = "<span style=\"font-family: sans-serif; font-size: 12.8px; line-height: 19.2px; background-color: rgb(255, 255, 255);\">быть:</span><ul style=\"line-height: 19.2px; margin: 0.3em 0px 0px 1.6em; padding: 0px; list-style-image: url(&quot;data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAANAQMAAABb8jbLAAAABlBMVEX///8AUow5QSOjAAAAAXRSTlMAQObYZgAAABNJREFUCB1jYEABBQw/wLCAgQEAGpIDyT0IVcsAAAAASUVORK5CYII=&quot;); font-family: sans-serif; font-size: 12.8px; background-color: rgb(255, 255, 255);\"><li style=\"margin-bottom: 0.1em;\">Карточка конкретного объекта.</li></ul>"
        
        html += "<ul><li>hhhh</li></ul><br/><b>Hello</b><font face=\"sans-serif\"> world</font>" + "<font face=\"sans-serif\"><span>й-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакойй-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакой</span></font>" +
            "<font face=\"sans-serif\"><span style=\"-webkit-tap-highlight-color: rgba(26, 26, 26, 0.301961); -webkit-text-size-adjust: 100%; background-color: rgba(255, 255, 255, 0);\">й-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакойй-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакой-то любой тексткакой</span></font></div>"
            
        
        toolbar.editor?.setHTML(html)

        var options = toolbar.options
        options.append(item)
        toolbar.options = options
    }

}

extension ViewController: RichEditorDelegate {

    func richEditor(editor: RichEditorView, heightDidChange height: Int) { }

    func richEditor(editor: RichEditorView, contentDidChange content: String) {
        if content.isEmpty {
            htmlTextView.text = "HTML Preview"
        } else {
            htmlTextView.text = content
        }
    }

    func richEditorTookFocus(editor: RichEditorView) { }
    
    func richEditorLostFocus(editor: RichEditorView) { }
    
    func richEditorDidLoad(editor: RichEditorView) { }
    
    func richEditor(editor: RichEditorView, shouldInteractWithURL url: NSURL) -> Bool { return true }

    func richEditor(editor: RichEditorView, handleCustomAction content: String) { }
    
}

extension ViewController: RichEditorToolbarDelegate {
    
    func richEditorToolbarChangeFontSize(toolbar: RichEditorToolbar) {
        toolbar.editor?.setScalableFontSize(7)
    }

    private func randomColor() -> UIColor {
        let colors = [
            UIColor.redColor(),
            UIColor.orangeColor(),
            UIColor.yellowColor(),
            UIColor.greenColor(),
            UIColor.blueColor(),
            UIColor.purpleColor()
        ]

        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }

    func richEditorToolbarChangeTextColor(toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextColor(color)
    }

    func richEditorToolbarChangeBackgroundColor(toolbar: RichEditorToolbar) {
        let color = randomColor()
        toolbar.editor?.setTextBackgroundColor(color)
    }

    func richEditorToolbarInsertImage(toolbar: RichEditorToolbar) {
        toolbar.editor?.insertImage("http://gravatar.com/avatar/696cf5da599733261059de06c4d1fe22", alt: "Gravatar")
    }

    func richEditorToolbarChangeInsertLink(toolbar: RichEditorToolbar) {
        toolbar.editor?.insertLink("http://github.com/cjwirth/RichEditorView", title: "Github Link")
    }
}
