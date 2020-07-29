$(function() {
  'use strict';
  var timer = document.getElementById('timer');
  var min_plus = document.getElementById('min-plus');
  var min_minus = document.getElementById('min-minus');
  var sec_plus = document.getElementById('sec-plus');
  var sec_minus = document.getElementById('sec-minus');
  var reset = document.getElementById('reset');
  var start = document.getElementById('start');
  var vol_icon = document.getElementById('vol-icon');
  var startTime;
  var timeLeft = 0;
  var defaultTime = 1500000;
  var timeToCountDown = defaultTime;
  var intervalTime = 300000;
  var timerId;
  var isRunning = false;
  // "Reset クリック時はキャンセル音のみ鳴らす"
  var clickReset = false;
  var volume = 0.20;
  var masterVolume = volume;
  
  // ボタン連打に対応
  function playSound(sound) {
    var snd = document.getElementById(sound);
    snd.volume = masterVolume;
    snd.currentTime = 0;
    snd.play();
  }
  
  function updateTimer(t) {
    var d = new Date(t);
    var m = d.getMinutes();
    var s = d.getSeconds();
    var timerString;
    m = ('0' + m).slice(-2);
    s = ('0' + s).slice(-2);
    timerString = m + ':' + s;
    timer.textContent = timerString;
  
    // 時間が未設定の時は、設定ボタンのみ有効
    if (t > 0) {
      $("#start").prop('disabled', false);
      if (isRunning === true) {
        $("#reset").prop('disabled', true);
      } else {
        $("#reset").prop('disabled', false);
      }
    } else {
      $("#start").prop('disabled', true);
      $("#reset").prop('disabled', true);
      btnTimeDisabled();
    }
  }
  
  function countDown() {
    timerId = setTimeout(function() {
      timeLeft = timeToCountDown - (Date.now() - startTime);
      if (timeLeft < 0) {
        isRunning = false;
        if (clickReset == false) {
          playSound("decision6");
        }
        clickReset = false;
        start.innerHTML = '<i class="fas fa-play play-style"></i>'
        clearTimeout(timerId);
        timeLeft = 0;
        timeToCountDown = 0;
        updateTimer(timeLeft);
        $("#reset").prop('disabled', true);
        memo();
        return;
      }
      updateTimer(timeLeft);
      countDown();
    }, 10);
  }
  
  function btnTimeDisabled() {
    if (isRunning === true) {
      $("#min").prop('disabled', true);
      $("#min-plus").prop('disabled', true);
      $("#min-minus").prop('disabled', true);
      $("#sec").prop('disabled', true);
      $("#sec-plus").prop('disabled', true);
      $("#sec-minus").prop('disabled', true);
    } else {
      $("#min").prop('disabled', false);
      $("#min-plus").prop('disabled', false);
      $("#min-minus").prop('disabled', false);
      $("#sec").prop('disabled', false);
      $("#sec-plus").prop('disabled', false);
      $("#sec-minus").prop('disabled', false);
    }
  }
  
  function interval() {
    Swal.fire({
      icon: "success",
      title: "少し休みましょう",
      html: '残り <b></b>',
      timer: intervalTime,
      timerProgressBar: true,
      onBeforeOpen: () => {
        setInterval(() => {
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
        timeToCountDown = defaultTime;
        updateTimer(timeToCountDown);
      }
    }).then((result) => {
      if (result.dismiss === Swal.DismissReason.timer) {
        playSound("bath-out1");
      }
    })
  }
  
  function memo() {
    Swal.fire({
      title: 'タスクへメモを残す',
      html : 'ご自由にどうぞ',
      input : 'textarea',
      inputPlaceholder: 'ごゆるりと...'
    }).then(function(result) {
      if( result.value ){
        console.log(result.value);
      }
      playSound("bath-thapon1");
      interval();
    });
    timeToCountDown = intervalTime;
    updateTimer(timeToCountDown);
  }
  
  $('#vol-icon').on('click',function(){
    if (vol_icon.innerHTML.indexOf('up') !== -1) {
      vol_icon.innerHTML = '<i class="fas fa-volume-mute mute-style"></i>';
      masterVolume = 0;
    } else {
      vol_icon.innerHTML = '<i class="fas fa-volume-up vol-style"></i>';
      masterVolume = volume;
      playSound("decision22");
    }
  });
  
  start.addEventListener('click', function() {
    if (isRunning === false) {
      isRunning = true;
      btnTimeDisabled();
      start.innerHTML = '<i class="fas fa-pause pause-style"></i>';
      startTime = Date.now();
      countDown();
    } else {
      isRunning = false;
      $("#reset").prop('disabled', false);
      btnTimeDisabled();
      start.innerHTML = '<i class="fas fa-play play-style"></i>';
      timeToCountDown = timeLeft;
      clearTimeout(timerId);
    }
  });
  
  reset.addEventListener('click', function() {
    clickReset = true;
    playSound("cancel6");
    timeToCountDown = 0;
    $("#reset").prop('disabled', true);
    updateTimer(timeToCountDown);
  });
  
  min_plus.addEventListener('click', function() {
    clickReset = false;
    playSound("cursor1");
    timeToCountDown += 60 * 1000;
    if (timeToCountDown >= 60 * 60 * 1000) {
      timeToCountDown = 0;
    }
    updateTimer(timeToCountDown);
  });
  
  min_minus.addEventListener('click', function() {
    clickReset = false;
    playSound("cursor1");
    timeToCountDown -= 60 * 1000;
    if (timeToCountDown < 0) {
      timeToCountDown = 0;
    }
    updateTimer(timeToCountDown);
  });
  
  sec_plus.addEventListener('click', function() {
    clickReset = false;
    playSound("cursor2");
    timeToCountDown += 1000;
    if (timeToCountDown >= 60 * 60 * 1000) {
      timeToCountDown = 0;
    }
    updateTimer(timeToCountDown);
  });
  
  sec_minus.addEventListener('click', function() {
    clickReset = false;
    playSound("cursor2");
    timeToCountDown -= 1000;
    if (timeToCountDown < 0) {
      timeToCountDown = 0;
    }
    updateTimer(timeToCountDown);
  });
  
  // 分 選択
  $('#min-sel > .dropdown-item').on('click', function(){
    var min_sel = ($(this).attr('value'));
    var seconds = Math.floor((timeToCountDown % 60000) / 1000);
    var millis = (timeToCountDown % 60000) % 1000;

    timeToCountDown = min_sel * 60 * 1000 + seconds * 1000 + millis;
    updateTimer(timeToCountDown);
  });

  // 秒 選択
  $('#sec-sel > .dropdown-item').on('click', function(){
    var sec_sel = ($(this).attr('value'));
    var minutes = Math.floor(timeToCountDown / 60000);
    var millis = (timeToCountDown % 60000) % 1000;

    timeToCountDown = minutes * 60 * 1000 + sec_sel * 1000 + millis;
    updateTimer(timeToCountDown);
  });
      
  updateTimer(defaultTime);
});
