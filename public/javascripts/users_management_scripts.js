jQuery(document).ready(function(){
 var legal_index=0;
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

 jQuery('select#business_id').bind('change',function(){
    var business_id = jQuery(":selected", this).val();
    jQuery.getScript("/users_management/update_places/"+business_id);
  });
  
  jQuery('#resend_password_link').click(function(){
    jQuery(this).closest('form').submit();
  });
  
  jQuery('.add_link').click(function(){
    legal_index=legal_index+1;
    if (legal_index < total_legals){
    //var select_legal_type=jQuery('.legal_type_class').children()[1];
    //var input_legal_id=jQuery('.legal_type_class').children()[2];
    //select_legal_type.id="legal_types_"+legal_index;
    //input_legal_id.id="legal_ids_"+legal_index;
    //var select_legal_type=jQuery('.legal_type_class select');
    //var input_legal_id=jQuery('.legal_type_class input');
    //var select_legal_type_new=select_legal_type.replace(/legal_types_0/,"legal_types_"+legal_index);
    //var input_legal_id_new=input_legal_id.replace(/legal_ids_0/,"legal_ids_"+legal_index);
    //jQuery('.legal_type_class').append(select_legal_type);
    //jQuery('.legal_type_class').append(input_legal_id);
    var old_html=jQuery('.legals_div').html();
    var new_html1=old_html.replace(/legal_types_0/,"legal_types_"+legal_index);
    new_html2=new_html1.replace(/legal_ids_0/,"legal_ids_"+legal_index);
    new_html3=new_html2.replace(/add.png/,"remove.png");
    new_html4=new_html3.replace(/add_link/,"remove_link");
    jQuery('.legal_type_class').append("<div class=\"legals_div\">"+new_html4+"</div>");
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
