var KZ =  KZ || {};


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
    } else if ( (sel = document.selection) && sel.type != "Control") {
        // IE < 9
        var originalRange = sel.createRange();
        originalRange.collapse(true);
        sel.createRange().pasteHTML(html);
        var range = sel.createRange();
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
    if (charTyped === ',' || charTyped === '-') {
        // Insert a left-to-right mark (U+200E) then the actual comma
        pasteHtmlAtCaret('&#x200E;', false);
    }

    // Index numbers
    // *************
    // Make sure index numbers (ex: '4.') following an arabic/right-to-left word
    // are treated as left-to-right elements.
    // Otherwise, the BiDi algorithm thinks it belongs to the right-to-left word and places it wrong.
    // Further reading: https://www.w3.org/International/articles/inline-bidi-markup/
    else if ( /^\d+$/.test(charTyped) ) { //0-9 only
        pasteHtmlAtCaret('&#x200E;', false);
    }

};

var keyUpHandler = function (e) {
    // If current font style is italic, reset it when starting a new paragraph
    if (e.keyCode === 13) {
        KZ.trixEditorElement.editor.deactivateAttribute("italic");
    }

    // if before the cursor there is a normal space
    // and more character before there is an arabic character
    // then replace the normal space by a non-breaking space
    // in order to avoid breaking arabic composed words

    var range = KZ.trixEditorElement.editor.getSelectedRange();
    var text = KZ.trixEditor.text();

    // if there is no selection
    // and if there are at least 2 characters before the cursor
    // (one space and one arabic for the autocorrect to apply)
    if(range[0] > 1 && range[0] === range[1]) {
        var indexOfLastCharacterEntered = range[0] - 1;
        var lastCharacterEntered = text.charAt(indexOfLastCharacterEntered);

        if(/\s/g.test(lastCharacterEntered)) {
            var indexOfTheCharacterBeforeSpace = indexOfLastCharacterEntered - 1;
            var characterEnteredBeforeSpace = text.charAt(indexOfTheCharacterBeforeSpace);

            var arabic = /[\u0600-\u06FF]/;
            if(arabic.test(characterEnteredBeforeSpace)) {
                KZ.trixEditorElement.editor.setSelectedRange([range[0] - 1, range[0]]);

                // Alternative:
                // element.editor.deleteInDirection("backward");

                // Use a narrow no-break space to separate word parts without indicating a word boundary.
                KZ.trixEditorElement.editor.insertString("\u202F\u202F\u202F");
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
