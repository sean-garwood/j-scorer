// First effort at a method that will return the proper non-string values.
function toBool( string ) {
  switch ( string ) {
    case true:
    case "true":
      return true;
    case false:
    case "false":
      return false;
    case null:
    case "null":
      return null;
    case undefined:
    case "undefined":
      return undefined;
    default:
      throw "Could not convert " + string + " to Boolean.";
  }
}

// Replaces <div>s and <br>s that are auto-generated when a user presses Enter
// to create a newline in a category title with HTML line feed entity.
function fixLineBreaks( string ) {
  return string.replace( /<div>/g, "&#10;" )
               .replace( /<\/div>/g, "" )
               .replace( /<br>/g, "&#10;" )
               .replace( /<br \/>/g, "&#10;" )
}

// HACK: Line feed doesn't seem to display properly in the category area.
// Replace it with a <br> tag.
function htmlize( string ) {
  return string.replace( /&#10;/g, "<br>" )
}

// from accepted answer to stackoverflow.com/questions/4233265/
function placeCaretAtEnd(el) {
  if (typeof window.getSelection != "undefined" &&
      typeof document.createRange != "undefined") {
    var range = document.createRange();
    range.selectNodeContents(el);
    range.collapse(false);
    var sel = window.getSelection();
    sel.removeAllRanges();
    sel.addRange(range);
  } else if (typeof document.body.createTextRange != "undefined") {
    var textRange = document.body.createTextRange();
    textRange.moveToElementText(el);
    textRange.collapse(false);
    textRange.select();
  }
}

// from accepted answer to stackoverflow.com/questions/12243898/
jQuery.fn.selectText = function(){
  var doc = document;
  var element = this[0];
  // console.log(this, element);
  if (doc.body.createTextRange) {
    var range = document.body.createTextRange();
    range.moveToElementText(element);
    range.select();
  } else if (window.getSelection) {
    var selection = window.getSelection();
    var range = document.createRange();
    range.selectNodeContents(element);
    selection.removeAllRanges();
    selection.addRange(range);
  }
};