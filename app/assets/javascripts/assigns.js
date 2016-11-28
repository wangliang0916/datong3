$( function() {
  $("#user_name").autocomplete({
    source: "/users/search",
    delay: 500,
    select: function(event, ui){
      $(this).val(ui.item.label);
      $("#user_id").val(ui.item.value);
      event.preventDefault();
    }
  });
});
