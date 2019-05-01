$(document).ready( () => {
  console.log("Ready");
  $('.timer-controls a[data-remote]').on('ajax:success', (event, data) => {
    // set active attr on controls
    $('#timer-controls-' + data.id).attr('data-timer-active', data.active);

    // set timer to time elapsed on timer stop
    $('#timer-' + data.id + '-time-elapsed').text(data.time_elapsed);

    // setTimerButtonVisibility();
    updateButtons(data.id, data.active);
  });
});

// Handle showing the start/stop buttons
function updateButtons(timerId, active){
  const startBtn = $('#timer-controls-' + timerId).find('.start-timer-btn')[0];
  const stopBtn = $('#timer-controls-' + timerId).find('.stop-timer-btn')[0];
  startBtn.hidden = active;
  stopBtn.hidden = !active;
}
