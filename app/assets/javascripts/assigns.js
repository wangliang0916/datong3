$( function() {
  $("#user_name").autocomplete({
    source: "/users/get_by_name",
    delay: 500,
    select: function(event, ui){
      $(this).val(ui.item.label);
      $("#user_id").val(ui.item.value);
      event.preventDefault();
    }
  });
});
