jQuery(document).ready(function(){
 jQuery("select#user_role_id").bind('change',function(){
    var role_id = jQuery(this).val();
    jQuery.ajax({
        type: 'GET',
        url: '/check_role/'+role_id,
        success: function(data){
          if (data=="true"){
            jQuery('.businesses_list').show();
            jQuery('.places_list').show();
          }else{
            jQuery('.businesses_list').hide();
            jQuery('.places_list').hide();
          }
        }
      });   
  });
  jQuery(".tabs").tabs({
    select:function(e,ui){
    var data = jQuery(ui.tab).attr("data-c");
    }
  });
  jQuery('select#business_id').bind('change',function(){
    var business_id = jQuery(":selected", this).val();
    jQuery.getScript("/users_management/update_places/"+business_id);
  });
  
  jQuery('#action_id').live('change',function(){
    var action_id = jQuery(":selected", this).val();
    var id=jQuery('#user_id').val();
    var loadingImage = jQuery(this).nextAll('img');
    loadingImage.show();
    jQuery.ajax({
      type: 'GET',
      url: '/users_management/'+id+'/logged_actions?action_id='+action_id,
      success: function(data){
         loadingImage.hide();
         jQuery('#logged_actions_container').html(data);
      },
      error: function(data){
        loadingImage.hide();
      }
    });   
  });
  
  jQuery('#program_type_selector').bind('change',function(){
    var program_type_id = jQuery(":selected", this).val();
    if (program_type_id!=""){
      var user_id = jQuery('#user_id').val();
      var loadingImage = jQuery(this).nextAll('img');
      loadingImage.show();
      jQuery.ajax({
        type: 'GET',
        url: '/list_by_program_type/'+program_type_id+"/"+user_id,
        success: function(data){
         loadingImage.hide();
         jQuery('#listing_businesses_container').html(data);
        },
        error: function(data){
          loadingImage.hide();
        }
      });   
    }
  });
  
  jQuery('#resend_password_link').click(function(){
    jQuery(this).closest('form').submit();
  });
  
  jQuery('.deposit_link').click(function(){
    var form=jQuery(this).closest('form');
    if (form.find(':text').val()!=""){
      jQuery(this).closest('form').submit();
    }
  });
  
  jQuery('.manage_enroll_link').live('click', function(){
    var ele=jQuery(this)[0];
    var ele2=jQuery(this);
    var pt_id=ele.id;
    var user_id = jQuery('#user_id').val();
    var loadingImage = jQuery(this).nextAll('img');
    var enroll= ele.text=="Un-Enroll" ? 0 : 1 ;
    loadingImage.show();
    jQuery.ajax({
      type: 'GET',
      url: "/enrollments/"+user_id+"/"+pt_id+"/"+enroll,
      success: function(data){
        loadingImage.hide();
        if (data==0){
          ele2.text("Enroll");
          jQuery('#program_status_'+pt_id).html("Un-Enrolled");
        }else{
          ele2.text("Un-Enroll");
          jQuery('#program_status_'+pt_id).html("Enrolled");
        }
      },
      error: function(data){
        loadingImage.hide();
      }
      });
  });
  
  jQuery('.withdraw_link').click(function(){
    var form=jQuery(this).closest('form');
    if (form.find(':text').val()!=""){
      jQuery(this).closest('form').submit();
    }
  });
  
  jQuery('.redeem_link').click(function(){
    jQuery(this).closest('form').submit();
  });
  
  jQuery('.engage_link').click(function(){
    jQuery(this).closest('form').submit();
  });
  
  jQuery("input[name=btype]").click(function(e){
      jQuery(".row.mailing").toggle();
      jQuery(".row.billing").toggle();
  });
  
  jQuery('.add_link').click(function(){
    if (legal_index < total_legals){
      var old_html=jQuery('.legals_div').html();
      var new_html1=old_html.replace(/legal_types_0/,"legal_types_"+legal_index);
      new_html2=new_html1.replace(/legal_ids_0/,"legal_ids_"+legal_index);
      new_html3=new_html2.replace(/add.png/,"remove.png");
      new_html4=new_html3.replace(/add_link/,"remove_link");
      jQuery('.legal_type_class').append("<div class=\"legals_div\">"+new_html4+"</div>");
      legal_index=legal_index+1;
    }
  });
  jQuery('.remove_link').live('click',function(){
    jQuery(this).parent('.legals_div').remove();
    legal_index=legal_index-1;
  });
  jQuery("#datepicker").birthdaypicker({
    dateFormat: "bigEndian",
    monthFormat: "long",
    placeholder: false,
    hiddenDate: false
  });

  jQuery('#send_confirmation_email').click(function(){
    jQuery(this).closest('form').submit();
  });
  
  jQuery('#suspend_link').click(function(){
    var user_id = jQuery('#user_id').val();
    var loadingImage = jQuery(this).nextAll('img');
    loadingImage.show();
    jQuery.ajax({
        type: 'GET',
        url: '/suspend_user/'+user_id,
        success: function(data){
          loadingImage.hide();
          jQuery('#status').html(data);
        },
        error: function(data){
          loadingImage.hide();
        }
      });   
  });
  
  jQuery('#reissue_code').live("click",function(){
    var user_id = jQuery('#user_id').val();
    var loadingImage = jQuery(this).nextAll('img');
    loadingImage.show();
    jQuery.ajax({
        type: 'GET',
        url: '/reissue_code/'+user_id,
        success: function(data){
          loadingImage.hide();
          jQuery('#user_code').html(data);
        },
        error: function(data){
          loadingImage.hide();
        }
      });   
  });
  
  jQuery('#reactivate_link').click(function(){
    var user_id = jQuery('#user_id').val();
    var loadingImage = jQuery(this).nextAll('img');
    loadingImage.show();
    jQuery.ajax({
        type: 'GET',
        url: '/reactivate_user/'+user_id,
        success: function(data){
          loadingImage.hide();
          jQuery('#status').html(data);
        },
        error: function(data){
          loadingImage.hide();
        }
      });   
  });
  
  jQuery('.U_email, .U_username').bind('change',function(){
    var field=jQuery(this);
    if(field.val() !=null){
      var fieldName=field[0].name;
      var loadingImage = field.nextAll('img');
      var successContainer = field.nextAll('.L-success');
      var errorContainer = field.nextAll('.L-error');
      var n1=fieldName.replace("user[","");
      var attributeName=n1.replace("]","");
      loadingImage.show();
      jQuery.ajax({
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
  
  jQuery('select#user_mailing_address_attributes_country_id').bind('change',function(){
    var country_id = jQuery(":selected", this).val();
    jQuery.getScript("/users_management/update_cities/"+country_id+"?selector_id=user_mailing_address_attributes_city_id");
  });
  
  jQuery('select#user_billing_address_attributes_country_id').bind('change',function(){
    var country_id = jQuery(":selected", this).val();
    jQuery.getScript("/users_management/update_cities/"+country_id+"?selector_id=user_billing_address_attributes_city_id");
  });
});
