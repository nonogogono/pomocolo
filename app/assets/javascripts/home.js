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
  check_task_name('#task-name-field', '#add-btn-task')

  // field が空欄であれば button を無効にする
  function check_field(field, button) {
    $(button).prop("disabled", true);

    $(field).change(function() {
      let flag = true;
      if ($.trim($(field).val()) === "") {
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

  //field が空欄であれば button を無効にする
  //同名のタスクが登録済みであれば alert を出して無効にする
  function check_task_name(field, button) {
    $(button).prop("disabled", true);

    $(field).change(function() {
      let new_task = $(field).val()
      let blank_flag = true;
      let repetition_flag = true;

      if ($.trim($(field).val()) === "") {
          blank_flag = false;
      }

      // index は引数に必須
      $('.tasks .name').each(function(index, element) {
        if ( new_task == $(element).text() ) {
          repetition_flag = false;
          alert('既に登録されているタスクです');
          return false;
        }
      });

      if (blank_flag && repetition_flag) {
        $(button).prop("disabled", false);
      }
      else {
        $(button).prop("disabled", true);
      }
    });
  }
});
