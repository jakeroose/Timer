// BUG: When starting timers or loading page with an active timer, there is a 1 sec delay
//  for the time elapsed to update.
$(document).ready( () => {
  console.log("Ready");

  // Handle updating timer info when started / stopeed
  $('.timer-controls a[data-remote]').on('ajax:success', (event, data) => {
    const timerContainer = $('#timer-container-' + data.id);

    // Update timer data from response
    timerContainer.attr('data-start-time', new Date(data.start_time).getTime()/1000);
    timerContainer.attr('data-time-elapsed', data.time_elapsed);
    timerContainer.attr('data-timer-active', data.active);

    // Update time elapsed
    setTimeElapsed(data.id, data.time_elapsed);

    // setTimerButtonVisibility();
    updateButtons(data.id, data.active);
  });

  // Seems to be a pause when starting timer back up...
  startActiveTimers();
});

// tells all timers to update every second.
function startActiveTimers(){
  $('.timer-container').each((i, el) => {
    const timerId = $(el).attr('data-timer-id');
    window.setInterval(() => updateElapsedTime(timerId), 1000);
  });
}


// Update time elapsed visually
function updateElapsedTime(timerId){
  if(timerActive(timerId) == "false") return;
  const timerContainer = $('#timer-container-' + timerId);
  const now = new Date().getTime(); // current time in miliseconds

  // Get start time - uses miliseconds to initialize
  const startTime = new Date(timerContainer.attr('data-start-time') * 1000);
  const timeElapsed = parseInt(timerContainer.attr('data-time-elapsed'));

  // set timer to time elapsed on timer stop
  setTimeElapsed(timerId, (now - startTime) / 1000 + timeElapsed); // convert back to seconds
}

function timerActive(timerId){
  return $('#timer-container-' + timerId).attr('data-timer-active');
}

// Visually updates timer
function setTimeElapsed(timerId, seconds){
  $('#timer-' + timerId + '-time-elapsed').text(formatSeconds(seconds));
}

// Handle showing the start/stop buttons
function updateButtons(timerId, active){
  const startBtn = $('#timer-controls-' + timerId).find('.start-timer-btn')[0];
  const stopBtn = $('#timer-controls-' + timerId).find('.stop-timer-btn')[0];
  startBtn.hidden = active;
  stopBtn.hidden = !active;
}

// Format secs to "hh:mm:ss"
function formatSeconds(secs){
  let hours = Math.floor(secs/3600);
  let minutes = Math.floor((secs - (hours * 3600)) / 60);
  let seconds = Math.floor(secs - (hours * 3600) - (minutes * 60));

  if(hours < 10) hours = "0" + hours;
  if(minutes < 10) minutes = "0" + minutes;
  if(seconds < 10) seconds = "0" + seconds;

  return hours + ":" + minutes + ":" + seconds;
}
