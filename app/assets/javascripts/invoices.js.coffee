# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery(document).ready () ->


  jQuery( '.datepicker' ).datepicker({
  })

  jQuery('.link_add_invoice_item').click -> 
    new_invoice_item = jQuery('#new_invoice_item').html();
    new_invoice_item = new_invoice_item.replace(/new_invoice_item_field/g, new Date().getTime())
    jQuery('#new_invoice_item').before('<tr>'+new_invoice_item+'<tr>');

    jQuery('.delete_before_el').on 'click', (event) ->
      removeInvoiceItem (jQuery(this))

    return null;

  jQuery('.delete_before_el').on 'click', (event) ->
      removeInvoiceItem( jQuery(this))

removeInvoiceItem = (link_delete_el) -> 
  jQuery(link_delete_el).parent().parent().remove();
