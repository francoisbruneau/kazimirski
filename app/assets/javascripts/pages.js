var KZ =  KZ || {};
KZ.arabicRegex = /[\u0600-\u06FF]/;

// https://gist.github.com/michelcmorel/6725279
// add html elements inside content editable area, credits Tim Down on stackoverflow.
// original post at:http://stackoverflow.com/questions/6690752/insert-html-at-caret-in-a-contenteditable-div
function pasteHtmlAtCaret(html, selectPastedContent) {
    var sel, range;
    if (window.getSelection) {
        // IE9 and non-IE
        sel = window.getSelection();
        if (sel.getRangeAt && sel.rangeCount) {
            range = sel.getRangeAt(0);
            range.deleteContents();

            // Range.createContextualFragment() would be useful here but is
            // only relatively recently standardized and is not supported in
            // some browsers (IE9, for one)
            var el = document.createElement("div");
            el.innerHTML = html;
            var frag = document.createDocumentFragment(), node, lastNode;
            while ( (node = el.firstChild) ) {
                lastNode = frag.appendChild(node);
            }
            var firstNode = frag.firstChild;
            range.insertNode(frag);

            // Preserve the selection
            if (lastNode) {
                range = range.cloneRange();
                range.setStartAfter(lastNode);
                if (selectPastedContent) {
                    range.setStartBefore(firstNode);
                } else {
                    range.collapse(true);
                }
                sel.removeAllRanges();
                sel.addRange(range);
            }
        }
    } else if ( (sel = document.selection) && sel.type !== "Control") {
        // IE < 9
        var originalRange = sel.createRange();
        originalRange.collapse(true);
        sel.createRange().pasteHTML(html);
        range = sel.createRange();
        range.setEndPoint("StartToStart", originalRange);
        range.select();
    }
}

var keyPressHandler = function (e) {
    e = e || window.event;
    var charCode = e.which || e.keyCode;
    var charTyped = String.fromCharCode(charCode);

    // Autocorrect logic
    // -----------------

    // Commas (same logic for dashes)
    // ******************************
    // Synonyms are usually separated by commas. They should appear
    // in the order in which they are typed, i.e. left-to-right.
    // But by default, BiDi algorithm treats the list of synonyms
    // as a right-to-left sentence, and the words order is reversed.
    // To fix this, we insert a left-to-right mark before each comma character
    // in order to force a left-to-right word sequence.
    if (charTyped === ',' || charTyped === '-' || charTyped === '—') {
        // Insert a left-to-right mark (U+200E) then the actual comma
        pasteHtmlAtCaret('&#x200E;', false);
    }

    // Index numbers
    // *************
    // Make sure index numbers (ex: '4.') following an arabic/right-to-left word
    // are treated as left-to-right elements.
    // Otherwise, the BiDi algorithm thinks it belongs to the right-to-left word and places it wrong.
    // Further reading: https://www.w3.org/International/articles/inline-bidi-markup/
    else if ( /^\d$/.test(charTyped) ) { //0-9 only
        pasteHtmlAtCaret('&#x200E;', false);
    }

};

var keyUpHandler = function (e) {
    // If current font style is italic, reset it when starting a new paragraph
    if (e.keyCode === 13) {
        KZ.trixEditorElement.editor.deactivateAttribute("italic");
    }

    var currentRange = KZ.trixEditorElement.editor.getSelectedRange(); // returns a array of indexes, not a DOM Range

    // Delayed auto-correction
    // i.e. for things were reliability is critical (i.e. replacing normal spaces by non-breaking ones
    // to preserve compound word meaning.)
    // ******************************************************************************************

    if (!KZ.scheduledAutocorrect) {
        KZ.scheduledAutocorrect = true;
        setTimeout(function() {
            KZ.scheduledAutocorrect = false;

            // Refresh the current range since it may have changed in the last 250ms (execution delay for the autocorrect)
            currentRange = KZ.trixEditorElement.editor.getSelectedRange();
            var document = KZ.trixEditorElement.editor.getDocument();
            var str = document.toString();

            var i;
            var length = str.length;
            var previousCharCode;
            for (i = 0; i < length; i++) {
                var charCode = str.charCodeAt(i);

                // Replace simple dash by long one
                if (charCode === 45) {
                    KZ.trixEditorElement.editor.setSelectedRange([i, i+1]);
                    KZ.trixEditorElement.editor.insertString("—");
                    KZ.trixEditorElement.editor.setSelectedRange(currentRange);
                }

                // Replace regular space between two arabic compound words
                // by a narrow no-break space
                // in order to separate word parts without indicating a word boundary.
                else if (charCode === 32 && previousCharCode ) {
                    if (previousCharCode >= 0x0600 && previousCharCode <= 0x06FF) {
                        KZ.trixEditorElement.editor.setSelectedRange([i, i+1]);
                        KZ.trixEditorElement.editor.insertString("\u202F");

                        // Add two more narrow spaces for reading comfort
                        KZ.trixEditorElement.editor.setSelectedRange([i+1, i+1]);
                        KZ.trixEditorElement.editor.insertString("\u202F\u202F");

                        // Restore the user's current range with a two character shift
                        // since two new characters were added.
                        var adaptedRangeStart = currentRange[0] + 2;
                        var adaptedRangeEnd = currentRange[1] + 2;
                        var adaptedRange = [adaptedRangeStart, adaptedRangeEnd];
                        KZ.trixEditorElement.editor.setSelectedRange(adaptedRange);
                    }
                }
                previousCharCode = charCode;
            }
        }, 250);
    }



    // As-you-type behaviour (i.e. disable italic when starting to type arabic)
    // i.e. not a big deal if we miss one in case the actual range
    // no longer matches the one when the character was entered
    // by the time the event is processed.
    // *****************************************************************************************

    // if there is no selection
    // and if there are at least 2 characters before the cursor
    // (one space and one arabic for the autocorrect to apply)
    if(currentRange[0] > 1 && currentRange[0] === currentRange[1]) {
        var sel = window.getSelection();
        var originalDomRange = sel.getRangeAt(0);

        // The actual DOM range might be at the beginning of a node,
        // For instance right after inserting a dash '-' character inside a word.
        if (originalDomRange.startOffset > 1) {
            var extendedDomRange = document.createRange();
            extendedDomRange.setStart(originalDomRange.startContainer, originalDomRange.startOffset - 2);
            extendedDomRange.setEnd(originalDomRange.endContainer, originalDomRange.startOffset);

            var clonedSelection = extendedDomRange.cloneContents();
            var div = document.createElement('div');
            div.appendChild(clonedSelection);
            var content = div.innerText;

            var lastCharacterEntered = content[1];

            // If last character was arabic, disable italic
            if (KZ.arabicRegex.test(lastCharacterEntered)) {
                KZ.trixEditorElement.editor.setSelectedRange([currentRange[0] - 1, currentRange[0]]);
                KZ.trixEditorElement.editor.deactivateAttribute("italic");
                KZ.trixEditorElement.editor.setSelectedRange([currentRange[0], currentRange[0]]);
            }
        }
    }
};


// Display the transcription instructions on first use.
jQuery(document).ready(function() {
    if(!Cookies.get('transcriptionInstructionsDismissed')) {
        Cookies.set('transcriptionInstructionsDismissed', true);
        jQuery('#instructions-modal').modal();
    }

    KZ.trixEditor = $('trix-editor');
    KZ.trixEditorElement = KZ.trixEditor[0];

    KZ.scheduledAutocorrect = false; // flag used to manage delayed autocorrection

    KZ.trixEditor.on("keypress", keyPressHandler).on("keyup", keyUpHandler);

    // Make the editor toolbar float over the text
    // When the virtual keyboard is shown on iOS
    // In order to make sure the buttons are always accessible.
    var headerSize = 60;
    var trixToolbar;
    var scrollY;

    $(window).scroll(function() {
        if(!trixToolbar) {
            trixToolbar = $('trix-toolbar');
        }

        trixToolbar.hide();
        setTimeout(function() {
            trixToolbar.show();
            scrollY = window.scrollY;
            if(scrollY > headerSize) {
                trixToolbar.css('top', scrollY - headerSize);
                trixToolbar.addClass('floating');
            } else {
                trixToolbar.css('top', '0px');
                trixToolbar.removeClass('floating');
            }
        }, 1000);
    });
});
