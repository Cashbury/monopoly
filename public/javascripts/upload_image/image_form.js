$(function () {

    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
      previewMaxWidth: 135,
      previewMaxHeight: 125,
      previewAsCanvas: false,
      acceptFileTypes: /\.(jpg|jpeg|gif|png|JPG|JPEG|GIF|PNG)$/
    });

    $(".clear_image_link").click(function(){      
      $(".L-current_image").hide();
      $(".L-default_image").show();
      $(".fake_file_input").hide();
      $(".clear_image_link").hide();
      $(".L-clear_confirmation").show();
      $(".update_btn").attr("disabled", "disabled");

      
      if($("#user_user_image_attributes_id").size() != 0)
        $("#user_user_image_attributes_id").remove();      
    });

    $(".confirm_clear").click(function(){      
      $.ajax({
        type: "POST",
        url: "clear_image",
        data: {
        },
        success: function(data) {
          if (data) {
            $(".L-current_image").hide();
            $(".L-default_image").show();
            $(".L-clear_confirmation").hide();
            $(".fake_file_input").show();
            $(".clear_image_link").show();
            $(".update_btn").removeAttr("disabled");            
          }
        },
        error: function(data) {}
        });
    });

    $(".cancel_clear").click(function(){
      $(".L-clear_confirmation").hide();
      $(".L-default_image").hide();
      $(".L-current_image").show();
      $(".fake_file_input").show();
      $(".clear_image_link").show(); 
      $(".update_btn").removeAttr("disabled");     
    });

    $("input:file").change(function(){
      $(".clear_image_link").hide();
      $(".fake_file_input").hide();
      if (!$(".update_btn").hasClass("L-create"))
        $(".update_btn").attr("disabled", "disabled");

    });    
    $('#loader').hide().ajaxStart(function() {
      return $(this).show();
    }).ajaxStop(function() {
      return $(this).hide();
    });

});