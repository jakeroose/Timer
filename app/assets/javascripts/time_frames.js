$(document).on('turbolinks:load', () => {
  console.log('Ready!');
  initializeAllTimers();
});

// Called on page load to set up all observers for the timers
function initializeAllTimers(){
  $('.timer-container').each((i, el) => {
    initializeTimer($(el).attr('data-timer-id'));
  });
}

// This sets up all of the observers we need for a timer
function initializeTimer(timerId){
  setupTimerButtonObservers(timerId);
  updateElapsedTime(timerId);
  // Start the timer so that it updates every second when active
  window.setInterval(() => updateElapsedTime(timerId), 1000);
  setupDescriptionObservers(timerId);
}

// Visually updates time elapsed for a timer
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

// Handles showing the form for a timer description
function setupDescriptionObservers(timerId){
  // Show description form when user clicks on timer description
  $('#timer-' + timerId + '-description-text').on('click', (e) => {
    $(e.target).hide();
    const timerId = $(e.target).attr('data-timer-id');
    const form = $('#timer-' + timerId + '-description-form');
    $('#timer-' + timerId + '-description-form').show();
    form.find('input').focus();
  });

  // when user submits new description, render new timer
  $('#edit_time_frame_' + timerId).on('ajax:success', (event, data) => {
    $('#timer-list-item-' + timerId).html(data);

    // Re initialize observers for this timer
    initializeTimer(timerId);
  });
}

// Shows correct timer button and updates the HTML data needed to display the timer
function setupTimerButtonObservers(timerId){
  // Handle updating timer info when started / stopped
  $('#timer-controls-' + timerId + ' a[data-remote]').on('ajax:success', (event, data) => {
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
}

// Sets time elapsed for timer to seconds
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

// === Helpers ===

// Checks if timer with id=timerId is active
function timerActive(timerId){
  return $('#timer-container-' + timerId).attr('data-timer-active');
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
