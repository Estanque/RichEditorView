/**
 * Copyright (C) 2015 Wasabeef
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

window.onload = function() {
    RE.callback("ready");
    RE.initTouchEventListeners();
};

var RE = {};

RE.currentSelection;

RE.isDragging = false;

RE.editor = document.getElementById('editor');

RE.initTouchEventListeners = function() {
    
    // Make sure that when we tap anywhere in the document we focus on the editor
    window.addEventListener('touchmove', function(event) {
        RE.isDragging = true;
    }, false);
    window.addEventListener('touchstart', function(event) {
        RE.isDragging = false;
                            
    }, false);
    window.addEventListener('touchend', function(event) {
        if (!RE.isDragging && (document.activeElement !== RE.editor)) {
            setEndOfContenteditable(RE.editor);
            RE.editor.focus();
        }
    }, false);
};

/**
 *  Sets the focus at the end of the editable element
 */
function setEndOfContenteditable(contentEditableElement) {
    var range,selection;
    if(document.createRange) {
        range = document.createRange();//Create a range (a range is a like the seElection but invisible)
        range.selectNodeContents(contentEditableElement);//Select the entire contents of the element with the range
        range.collapse(false);//collapse the range to the end point. false means collapse to end rather than the start
        selection = window.getSelection();//get the selection object (allows you to change selection)
        selection.removeAllRanges();//remove any selections already made
        selection.addRange(range);//make the range you have just created the visible selection
    }
}

// Not universally supported, but seems to work in iOS 7 and 8
document.addEventListener("selectionchange", function() { RE.backuprange(); });

RE.editor.addEventListener("input", function() {
    RE.updatePlaceholder();
    RE.backuprange();
    RE.callback("input");
});

RE.editor.addEventListener("focus", function() {
    RE.backuprange();
    RE.callback("focus");
});

RE.editor.addEventListener("blur", function() {
    RE.callback("blur");
});

RE.customAction = function(action) {
    RE.callback("action/" + action);
}

RE.callbackQueue = [];
RE.runCallbackQueue = function() {
    if (RE.callbackQueue.length == 0) {
        return;
    }
    
    setTimeout(function() {
        window.location.href = "re-callback://";    
    }, 0);
}

RE.getCommandQueue = function() {
    var commands = JSON.stringify(RE.callbackQueue);
    RE.callbackQueue = [];
    return commands;
}

RE.callback = function(method) {
    RE.callbackQueue.push(method);
    RE.runCallbackQueue();
}

RE.setHtml = function(contents) {
    RE.editor.innerHTML = contents;
    RE.updatePlaceholder();
}

RE.getHtml = function() {
    return RE.editor.innerHTML;
}

RE.getText = function() {
    return RE.editor.innerText;
}

RE.setPlaceholderText = function(text) {
    RE.editor.setAttribute("placeholder", text);
}

RE.updatePlaceholder = function() {
    if (RE.editor.textContent.length > 0) {
        RE.editor.classList.remove("placeholder");
    } else {
        RE.editor.classList.add("placeholder");
    }
}

RE.removeFormat = function() {
    document.execCommand('removeFormat', false, null);
}

RE.setFontSize = function(size) {
    RE.editor.style.fontSize = size;
}

RE.setBackgroundColor = function(color) {
    RE.editor.style.backgroundColor = color;
}

RE.setHeight = function(size) {
    RE.editor.style.height = size;
}

RE.undo = function() {
    document.execCommand('undo', false, null);
}

RE.redo = function() {
    document.execCommand('redo', false, null);
}

RE.setBold = function() {
    document.execCommand('bold', false, null);
}

RE.setItalic = function() {
    document.execCommand('italic', false, null);
}

RE.setSubscript = function() {
    document.execCommand('subscript', false, null);
}

RE.setSuperscript = function() {
    document.execCommand('superscript', false, null);
}

RE.setStrikeThrough = function() {
    document.execCommand('strikeThrough', false, null);
}

RE.setUnderline = function() {
    document.execCommand('underline', false, null);
}

RE.setTextColor = function(color) {
    RE.restorerange();
    document.execCommand("styleWithCSS", null, true);
    document.execCommand('foreColor', false, color);
    document.execCommand("styleWithCSS", null, false);
}

RE.setTextBackgroundColor = function(color) {
    RE.restorerange();
    document.execCommand("styleWithCSS", null, true);
    document.execCommand('hiliteColor', false, color);
    document.execCommand("styleWithCSS", null, false);
}

RE.setHeading = function(heading) {
    document.execCommand('formatBlock', false, '<h'+heading+'>');
}

RE.setIndent = function() {
    document.execCommand('indent', false, null);
}

RE.setOutdent = function() {
    document.execCommand('outdent', false, null);
}

RE.setOrderedList = function() {
    document.execCommand('insertOrderedList', false, null);
}

RE.setUnorderedList = function() {
    document.execCommand('insertUnorderedList', false, null);
}

RE.setJustifyLeft = function() {
    document.execCommand('justifyLeft', false, null);
}

RE.setJustifyCenter = function() {
    document.execCommand('justifyCenter', false, null);
}

RE.setJustifyRight = function() {
    document.execCommand('justifyRight', false, null);
}

RE.insertImage = function(url, alt) {
    var html = '<img src="' + url + '" alt="' + alt + '" />';
    RE.insertHTML(html);
    RE.callback("input");
}

RE.insertBase64Image = function(base64) {
    var html = '<img src="data:image/png;base64,' + base64 + '" />';
    RE.insertHTML(html);
    RE.callback("input");
}

RE.setBlockquote = function() {
    document.execCommand('formatBlock', false, '<blockquote>');
}

RE.insertHTML = function(html) {
    RE.restorerange();
    document.execCommand('insertHTML', false, html);
}

RE.insertLink = function(url, title) {
    RE.restorerange();
    var sel = document.getSelection();
    if (sel.toString().length != 0) {
        if (sel.rangeCount) {

            var el = document.createElement("a");
            el.setAttribute("href", url);
            el.setAttribute("title", title);

            var range = sel.getRangeAt(0).cloneRange();
            range.surroundContents(el);
            sel.removeAllRanges();
            sel.addRange(range);
        }
    }
    RE.callback("input");
}

RE.quickLink = function() {
    
    var sel = document.getSelection();
    var link_url = "";
    var test = new String(sel);
    var mailregexp = new RegExp("^(.+)(\@)(.+)$", "gi");
    if (test.search(mailregexp) == -1) {
        checkhttplink = new RegExp("^http\:\/\/", "gi");
        if (test.search(checkhttplink) == -1) {
            checkanchorlink = new RegExp("^\#", "gi");
            if (test.search(checkanchorlink) == -1) {
                link_url = "http://" + sel;
            } else {
                link_url = sel;
            }
        } else {
            link_url = sel;
        }
    } else {
        checkmaillink = new RegExp("^mailto\:", "gi");
        if (test.search(checkmaillink) == -1) {
            link_url = "mailto:" + sel;
        } else {
            link_url = sel;
        }
    }
    
    var html_code = '<a href="' + link_url + '">' + sel + '</a>';
    RE.insertHTML(html_code);
    
}

RE.prepareInsert = function() {
    RE.backuprange();
}

RE.backuprange = function(){
    var selection = window.getSelection();
    if (selection.rangeCount > 0) {
        var range = selection.getRangeAt(0);
        RE.currentSelection = {
            "startContainer": range.startContainer,
            "startOffset": range.startOffset,
            "endContainer": range.endContainer,
            "endOffset": range.endOffset};
    }
}

RE.restorerange = function(){
    var selection = window.getSelection();
    selection.removeAllRanges();
    var range = document.createRange();
    range.setStart(RE.currentSelection.startContainer, RE.currentSelection.startOffset);
    range.setEnd(RE.currentSelection.endContainer, RE.currentSelection.endOffset);
    selection.addRange(range);
}

RE.focus = function() {
    var range = document.createRange();
    range.selectNodeContents(RE.editor);
    range.collapse(false);
    var selection = window.getSelection();
    selection.removeAllRanges();
    selection.addRange(range);
    RE.editor.focus();
}

RE.blurFocus = function() {
    RE.editor.blur();
}