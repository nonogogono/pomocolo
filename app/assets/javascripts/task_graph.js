$(function() {
  // 集計の最大日数
  var term = 31;

  $('.value').each(function() {
    var text = $(this).text();
    $(this).parent().css('width', text*1.5);
  });

  $('.block').tooltip();

  for( var i=0; i<=term; i++ ) {
    var block_count = $(`#chart-${i} .block`).length;

    for( var j=0; j<block_count; j++ ) {
      var block_class = `#chart-${i} .block:nth-of-type(${j+1})`;
      same_as_legend_color(block_class);
    }
  }

  function same_as_legend_color(block_class) {
    var block_id = $(block_class).attr('id');

    for (var i=0; i<20; i++) {      
      if( block_id == $(`.legend li:nth-of-type(${i+1})`).text()) {
        $(block_class).css('background-color', `var(--task-color-${i+1})`);
        return;
      }
    }
  }
});
