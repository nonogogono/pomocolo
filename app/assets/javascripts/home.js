$(function() {
  if($.cookie("openTag")){
   $('a[data-toggle="tab"]').parent().removeClass('active');
   $('a[href="#' + $.cookie("openTag") +'"]').click();
  }

  $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
   var tabName = e.target.href;
   var items = tabName.split("#");
   $.cookie("openTag",items[1], { expires: 1 });
  });

  // check_field('#micropost-content-area', '#btn-post')
  check_field('#search-field-user', '#search-btn-user')
  check_field('#search-field-micropost', '#search-btn-micropost')

  // field が空欄であれば button を無効にする
  function check_field(field, button) {
    $(button).prop("disabled", true);

    $(field).change(function () {
      let flag = true;
      if ($(field).val() === "") {
          flag = false;
      }
      if (flag) {
          $(button).prop("disabled", false);
      }
      else {
          $(button).prop("disabled", true);
      }
    });  
  }
});
