$(function() {
  'use strict';
  var timer = document.getElementById('timer');
  var start = document.getElementById('start');
  var vol_icon = document.getElementById('vol-icon');
  var startTime;
  var timeLeft = 0;
  var task_time = $('.set-task-time').val();
  var defaultTime = task_time * 60 * 1000;
  var timeToCountDown = defaultTime;
  var timerId;
  var isRunning = false;
  var volume = 0.20;
  var masterVolume = volume;

  updateTimer(defaultTime);

  $('#vol-icon').on('click', function(){
    if (vol_icon.innerHTML.indexOf('up') !== -1) {
      vol_icon.innerHTML = '<i class="fas fa-volume-mute mute-style"></i>';
      masterVolume = 0;
    } else {
      vol_icon.innerHTML = '<i class="fas fa-volume-up vol-style"></i>';
      masterVolume = volume;
      playSound("decision22");
    }
  });

  $('#start').on('click', function() {
    if (!($('.tasks').get(0))) {
      alert('タスクを登録してください');
      return false;
    }

    if (isRunning === false) {
      isRunning = true;
      start.innerHTML = '<i class="fas fa-pause pause-style"></i>';
      startTime = Date.now();
      countDown();
    } else {
      isRunning = false;
      start.innerHTML = '<i class="fas fa-play play-style"></i>';
      timeToCountDown = timeLeft;
      clearTimeout(timerId);
    }
  });

  // ボタン連打に対応
  function playSound(sound) {
    var snd = document.getElementById(sound);
    snd.volume = masterVolume;
    snd.currentTime = 0;
    snd.play();
  }
  
  function updateTimer(t) {
    var d = new Date(t);
    var h = d.getHours()
    var m = d.getMinutes();
    var s = d.getSeconds();
    var timerString;

    // あるいは
    // if (h == 10) {
    //   m = '60';
    // } else {
    //   m = ('0' + m).slice(-2);
    // }
    // s = ('0' + s).slice(-2);
    // timerString = m + ':' + s;

    if (h == 10) {
      timerString = '60:00';
    } else {
      m = ('0' + m).slice(-2);
      s = ('0' + s).slice(-2);
      timerString = m + ':' + s;
    }
    timer.textContent = timerString;
  
    // 時間が未設定の時は、設定ボタンのみ有効
    if (t > 0) {
      $("#start").prop('disabled', false);
    } else {
      $("#start").prop('disabled', true);
    }
  }
  
  function countDown() {
    timerId = setTimeout(function() {
      timeLeft = timeToCountDown - (Date.now() - startTime);
      if (timeLeft < 0) {
        isRunning = false;
        playSound("decision6");
        start.innerHTML = '<i class="fas fa-play play-style"></i>'
        clearTimeout(timerId);
        timeLeft = 0;
        timeToCountDown = 0;
        updateTimer(timeLeft);
        record_task();
        return;
      }
      updateTimer(timeLeft);
      countDown();
    }, 10);
  }

  //休憩用タイマー
  if ($("#break-time-on").text() == "on") {
    ready_to_break();
  }

  function ready_to_break() {
    Swal.fire({
      title: 'Break Time',
      html : ''
    }).then(function(result) {
      playSound("bath-thapon1");
      break_time();
    });
  }

  function break_time() {
    let timerInterval;
    let intervalTime = $('.set-break-time').val() * 60 * 1000;
    Swal.fire({
      icon: "success",
      title: "Break Time",
      html: '<b></b>',
      timer: intervalTime,
      timerProgressBar: true,
      onBeforeOpen: () => {
        timerInterval = setInterval(() => {
          const content = Swal.getContent()
          if (content) {
            const b = content.querySelector('b')
            if (b) {
              let intervalLeft = Swal.getTimerLeft();
              let m = Math.floor(intervalLeft / 60000);
              let s = Math.floor((intervalLeft % 60000) / 1000);
              m = ('0' + m).slice(-2);
              s = ('0' + s).slice(-2);
              b.textContent = m + ':' + s;
            }
          }
        }, 100)
      },
      onClose: () => {
        clearInterval(timerInterval)
      }
    }).then((result) => {
      if (result.dismiss === Swal.DismissReason.timer) {
        playSound("bath-out1");
      }
    })
  }

  //モーダルウィンドウで micropost_form を出現させる
  function record_task() {
    if( $("#modal-overlay")[0] ) return false;
    $("body").append('<div id="modal-overlay"></div>');
    $("#modal-overlay").fadeIn( 100 );
    $("#modal-content").html(
      $(".modal-open").prop('innerHTML')
    );
    $('#modal-content .modal-micropost-form').css('display','block');
    $('#modal-content').css('display','flex');
    $('#modal-content').css('align-items','center');
    centeringModalSyncer();
    $("#modal-content").fadeIn( 100 );
  }

  //リサイズされたら、センタリングをする
  $(window).resize(centeringModalSyncer);

  function centeringModalSyncer() {
    var w = $(window).width();
    var h = $(window).height();
    var cw = $("#modal-content").outerWidth();
    var ch = $("#modal-content").outerHeight();

    $("#modal-content").css( {"left": ((w - cw)/2) + "px","top": ((h - ch)/2) + "px"} );
  }
});
