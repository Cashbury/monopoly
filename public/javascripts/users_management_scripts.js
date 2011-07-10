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

 jQuery('select#business_id').bind('change',function(){
    var business_id = jQuery(":selected", this).val();
    jQuery.getScript("/users_management/update_places/"+business_id);
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
