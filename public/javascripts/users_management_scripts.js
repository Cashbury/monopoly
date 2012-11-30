$(document).ready(function(){
 $("select#user_role_id").bind('change',function(){
    var role_id = $(this).val();
    $.ajax({
        type: 'GET',
        url: '/check_role/'+role_id,
        success: function(data){
          if (data=="true"){
            $('.businesses_list').show();
            $('.places_list').show();
          }else{
            $('.businesses_list').hide();
            $('.places_list').hide();
          }
        }
      });   
  });
  $(".role_box").change(function(){
    if ($(this).is(":checked")){
      var role_ids = [];
      $("INPUT[type='checkbox']:checked").each(function(index, domEle) {
        role_ids.push($(domEle).val());
      });
      $('#loader').hide().unbind("ajaxStart");
      $.ajax({
        type: 'GET',
        url: '/check_role?role_ids='+role_ids,        
        success: function(data){
          if (data == "true"){
            $('.brands_list').show();
            $('.businesses_list').show();
            $('.places_list').show();
          }else{
            $('#brand_id').val("");
            $('#business_id').val("");
            $('#user_place_id').val("");
            $('.brands_list').hide();
            $('.businesses_list').hide();
            $('.places_list').hide();
          }
          re_enable_loader();
        }
      });
    } else {
      $('#brand_id').val("");
      $('#business_id').val("");
      $('#user_place_id').val("");
      $('.brands_list').hide();
      $('.businesses_list').hide();
      $('.places_list').hide();
    }
  });

  $(".tabs").tabs({
    select:function(e,ui){
      var data = $(ui.tab).attr("data-c");
    }
  });

  $('select#brand_id').bind('change',function(){
    var brand_id = $(":selected", this).val();
    $('#loader').hide().unbind("ajaxStart");
    $.getScript("/users_management/update_businesses/" + brand_id, function(data, textStatus, jqxhr){
      re_enable_loader();
    });
  });

  $('select#business_id').bind('change',function(){
    var business_id = $(":selected", this).val();
    $('#loader').hide().unbind("ajaxStart");
    $.getScript("/users_management/update_places/" + business_id, function(data, textStatus, jqxhr){
      re_enable_loader();
    });
  });
  
  $('#action_id').live('change',function(){
    var action_id = $(":selected", this).val();
    var id=$('#user_id').val();
    var loadingImage = $(this).nextAll('img');
    loadingImage.show();
    $.ajax({
      type: 'GET',
      url: '/users_management/'+id+'/logged_actions?action_id='+action_id,
      success: function(data){
         loadingImage.hide();
         $('#logged_actions_container').html(data);
      },
      error: function(data){
        loadingImage.hide();
      }
    });   
  });
  
  $('#program_type_selector').bind('change',function(){
    var program_type_id = $(":selected", this).val();
    if (program_type_id!=""){
      var user_id = $('#user_id').val();
      var loadingImage = $(this).nextAll('img');
      loadingImage.show();
      $.ajax({
        type: 'GET',
        url: '/list_by_program_type/'+program_type_id+"/"+user_id,
        success: function(data){
         loadingImage.hide();
         $('#listing_businesses_container').html(data);
        },
        error: function(data){
          loadingImage.hide();
        }
      });   
    }
  });
  
  $('#resend_password_link').click(function(){
    $(this).closest('form').submit();
  });
  
  $('.deposit_link').click(function(){
    var form=$(this).closest('form');
    if (form.find(':text').val()!=""){
      $(this).closest('form').submit();
    }
  });
  
  $('.manage_enroll_link').live('click', function(){
    var ele=$(this)[0];
    var ele2=$(this);
    var pt_id=ele.id;
    var user_id = $('#user_id').val();
    var loadingImage = $(this).nextAll('img');
    var enroll= ele.text=="Un-Enroll" ? 0 : 1 ;
    loadingImage.show();
    $.ajax({
      type: 'GET',
      url: "/enrollments/"+user_id+"/"+pt_id+"/"+enroll,
      success: function(data){
        loadingImage.hide();
        if (data == 0){
          ele2.text("Enroll");
          $('#program_status_'+pt_id).html("Un-Enrolled");
        }else{
          ele2.text("Un-Enroll");
          $('#program_status_'+pt_id).html("Enrolled");
        }
      },
      error: function(data){
        loadingImage.hide();
      }
    });
  });
  
  $('.manage_campaign_enroll_link').live('click', function(){
    var ele=$(this)[0];
    var ele2=$(this);
    var c_id=ele.id;
    var user_id = $('#user_id').val();
    var loadingImage = $(this).nextAll('img');
    var enroll= ele.text=="Un-Enroll" ? 0 : 1 ;
    loadingImage.show();
    $.ajax({
      type: 'GET',
      url: "/campaign_enrollments/"+user_id+"/"+c_id+"/"+enroll,
      success: function(data){
        loadingImage.hide();
        if (data==0){
          ele2.text("Enroll");
          $('#campaign_status_'+c_id).html("Un-Enrolled");
        }else{
          ele2.text("Un-Enroll");
          $('#campaign_status_'+c_id).html("Enrolled");
        }
      },
      error: function(data){
        loadingImage.hide();
      }
    });
  });
  
  $('.withdraw_link').click(function(){
    var form=$(this).closest('form');
    if (form.find(':text').val()!=""){
      $(this).closest('form').submit();
    }
  });
  
  $('.redeem_link').click(function(){
    $(this).closest('form').submit();
  });
  
  $('.engage_link').click(function(){
    $(this).closest('form').submit();
  });
  
  $("input[name=btype]").click(function(e){
      $(".row.mailing").toggle();
      $(".row.billing").toggle();
  });
  
  $('.add_link').click(function(){
    if (legal_index <= total_legals-1){
      var old_html = $('.legals_div').html();
      var new_html1 = old_html.replace(/legal_types_0/,"legal_types_"+legal_index);
      new_html2 = new_html1.replace(/legal_ids_0/,"legal_ids_"+legal_index);
      new_html3 = new_html2.replace(/add.png/,"remove.png");
      new_html4 = new_html3.replace(/add_link/,"remove_link");
      $('.legal_type_class').append("<div class=\"legals_div\">"+new_html4+"</div>");
      legal_index = legal_index+1;
    }
  });
  
  $('.remove_link').live('click',function(){
    $(this).parent('.legals_div').remove();
    legal_index=legal_index-1;
  });
  
  $("#datepicker").birthdaypicker({
    dateFormat: "bigEndian",
    monthFormat: "long",
    placeholder: false,
    hiddenDate: false
  });

  $('#send_confirmation_email').click(function(){
    $(this).closest('form').submit();
  });
  
  $('#suspend_link').click(function(){
    var user_id = $('#user_id').val();
    var loadingImage = $(this).nextAll('img');
    loadingImage.show();
    $.ajax({
        type: 'GET',
        url: '/suspend_user/'+user_id,
        success: function(data){
          loadingImage.hide();
          $('#status').html(data);
        },
        error: function(data){
          loadingImage.hide();
        }
      });   
  });
  
  $('#reissue_code').live("click",function(){
    var user_id = $('#user_id').val();
    var loadingImage = $(this).nextAll('img');
    loadingImage.show();
    $.ajax({
        type: 'GET',
        url: '/reissue_code/'+user_id,
        success: function(data){
          loadingImage.hide();
          $('.sum').html(data);
        },
        error: function(data){
          loadingImage.hide();
        }
      });   
  });
  
  $('#reactivate_link').click(function(){
    var user_id = $('#user_id').val();
    var loadingImage = $(this).nextAll('img');
    loadingImage.show();
    $.ajax({
        type: 'GET',
        url: '/reactivate_user/'+user_id,
        success: function(data){
          loadingImage.hide();
          $('#status').html(data);
        },
        error: function(data){
          loadingImage.hide();
        }
    });   
  });
  
  $('.U_email, .U_username').bind('change',function(){
    var field = $(this);
    if(field.val() != ""){
      var fieldName = field[0].name;
      var loadingImage = field.nextAll('img');
      var successContainer = field.nextAll('.L-success');
      var errorContainer = field.nextAll('.L-error');
      var n1 = fieldName.replace("user[","");
      var attributeName = n1.replace("]","");
      loadingImage.show();
      $.ajax({
        url: '/users_management/check_attribute_availability',
        type: 'post',
        data: {
          'attribute_name': attributeName,
          'attribute_value': field.val()
        },
        dataType: 'text',
        success: function(response){
          loadingImage.hide();
          errorContainer.html("");
          successContainer.html(response);
          successContainer.show();
        },
        error: function(response){
          loadingImage.hide();
          successContainer.html("");
          errorContainer.html(response.responseText);
          errorContainer.show();
        }
      });
    }
  });
  
  $('select#user_mailing_address_attributes_country_id').bind('change',function(){
    var country_id = $(":selected", this).val();
    $.getScript("/users_management/update_cities/"+country_id+"?selector_id=user_mailing_address_attributes_city_id");
  });
  
  $('select#user_billing_address_attributes_country_id').bind('change',function(){
    var country_id = $(":selected", this).val();
    $.getScript("/users_management/update_cities/"+country_id+"?selector_id=user_billing_address_attributes_city_id");
  });
});


function re_enable_loader() {
  $('#loader').hide().ajaxStart(function() {
    return $(this).show();
  }).ajaxStop(function() {
    return $(this).hide();
  });
}