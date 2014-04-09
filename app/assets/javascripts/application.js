// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the // the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function () {
    $(".review-form").hide();
    $(".reviews").hide();
    $(".note-form").hide();
    $(".grade-form").hide();

    $(".button#review-form").click(function (e) {
        $(".review-form").toggle();
    });
    $(".button#review").click(function (e) {
        $(".reviews").toggle();
    });
    $(".button#note-form").click(function (e) {
        $(".note-form").toggle();
    });
    $(".button#grade-form").click(function (e) {
        $(".grade-form").toggle();
    });

    $('#langfield input:radio').change(function() {
      var lang = $(this).val();
      if (lang == "other") {
        $('#otherlang').show().find('input').val("");
      } else {
        $('#otherlang').hide().find('input').val(lang);
      }
      console.log(lang);
    });

    $('table').rotateTableCellContent();

    var activateStudent = function (e){
      var id = e.target.id
      $("."+id).toggleClass( "activestudent" )
    };

    $(".activable").click(activateStudent);
    
    var reg_id = $("#current_registration").val();
    $("#select_grading").change(function() {
      $("#grader").load("/checklists/"+$(this).val()+"/user/"+reg_id, addAutosubmit);
    }).change();
    
    function addAutosubmit() {
      var submitting = false;
      $(".autograde input").change(function() {
        if (!submitting) {
          var form = $(this).parents('form');
          submitting = true;
          setTimeout(function() {
            submitting = false;
            $.ajax({
              type: "POST",
              url: form.attr('action'),
              data: form.serialize(), // serializes the form's elements.
              success: function(data)
              {
              }
            });
          }, 1000);
        }

        return false; // avoid to execute the actual submit of the form.
      });
    }
    
    //Checklist data editor
    if (document.getElementById("topics_yaml")) {
      var editor = CodeMirror.fromTextArea(document.getElementById("topics_yaml"), {
        lineNumbers: true,
        mode: "text/x-yaml",
        vimMode: true,
        showCursorWhenSelecting: true,
        tabSize: 2,
        extraKeys: {
          "Tab": function(cm) {
            if (typeof(cm.state.vim) != "undefined" && !cm.state.vim.insertMode && !cm.getSelection().length) {
              editor2.focus();
              document.getElementById("checklist_remarks").focus()
              return;
            }
            if (cm.getSelection().length)
              CodeMirror.commands.indentMore(cm)
            else 
              cm.replaceSelection("  ", "end")
          },
        }
      });
      var editor2 = CodeMirror.fromTextArea(document.getElementById("checklist_remarks"), {
        lineNumbers: true,
        mode: "text/x-markdown",
        vimMode: true,
        showCursorWhenSelecting: true
      });
    }
});


(function ($) {
  $.fn.rotateTableCellContent = function (options) {
  /*
  Version 1.0
  7/2011
  Written by David Votrubec (davidjs.com) and
  Michal Tehnik (@Mictech) for ST-Software.com
  */

		var cssClass = ((options) ? options.className : false) || "vertical";

		var cellsToRotate = $('.' + cssClass, this);

		var betterCells = [];
		cellsToRotate.each(function () {
			var cell = $(this)
		  , newText = cell.text()
		  , height = cell.height()
		  , width = cell.width()+20
		  , newDiv = $('<div>', { height: width, width: height })
		  , newInnerDiv = $('<div>', { text: newText, 'class': 'rotated' });

			newDiv.append(newInnerDiv);

			betterCells.push(newDiv);
		});

		cellsToRotate.each(function (i) {
			$(this).html(betterCells[i]);
		});
	};
})(jQuery);
