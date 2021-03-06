#
# * Copyright (c) Novedia Group 2012.
# *
# *    This file is part of Hubiquitus
# *
# *    Permission is hereby granted, free of charge, to any person obtaining a copy
# *    of this software and associated documentation files (the "Software"), to deal
# *    in the Software without restriction, including without limitation the rights
# *    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# *    of the Software, and to permit persons to whom the Software is furnished to do so,
# *    subject to the following conditions:
# *
# *    The above copyright notice and this permission notice shall be included in all copies
# *    or substantial portions of the Software.
# *
# *    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# *    INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
# *    PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
# *    FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# *    ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# *
# *    You should have received a copy of the MIT License along with Hubiquitus.
# *    If not, see <http://opensource.org/licenses/mit-license.php>.
#
{InboundAdapter} = require "./InboundAdapter"
cronJob = require("cron").CronJob

#
# Class that defines a timer Adapter.
# It is used to generate hMessage and send it to the actor every period (depending properties)
#
class TimerAdapter extends InboundAdapter

  # @property {object} task to perform
  job: undefined

  #
  # Adapter's constructor
  # @param properties {object} Launch properties of the adapter
  #
  constructor: (properties) ->
    super
    @job = undefined

  #
  # Method which run the task (sending hAlert to the actor).
  # You can override this method if you need specific job
  #
  startJob: =>
    current = new Date().getTime()
    msg = @owner.buildMessage(@owner.actor, "hAlert", {alert:@properties.alert}, {published:current})
    @owner.emit "message", msg

  #
  # Method which stop the task.
  # You can override this method if you need specific job
  #
  stopJob: =>
    # This function is executed when the job stops

  #
  # Method which launch the timer interval before running the job.
  # You can run the task every X millisecond or using a crontab depending the adapter properties.
  #
  launchTimer: ->
    if @properties.mode is "millisecond"
      @job = setInterval(=>
        @startJob()
      , @properties.period)
    else if @properties.mode is "crontab"
      try
        @job = new cronJob(@properties.crontab, =>
          @startJob()
        , =>
          @stopJob()
        , true, "Europe/London")
      catch err
        @owner.log "error", "Couldn't setup timer adapter : #{err}"
    else
      @owner.log "error", "Timer adapter : Unhandled mode #{@properties}"

  #
  # @overload start()
  #   Method which start the adapter.
  #   When this adapter is started, the timer task will be run.
  #
  start: ->
    unless @started
      @launchTimer()
      @owner.log "debug", "#{@owner.actor} launch TimerAdapter"
      super

  #
  # @overload stop()
  #   Method which stop the adapter.
  #   When this adapter is stopped, the timer task will end
  #
  stop: ->
    if @started
      if @properties.mode is "crontab" and @job
        @job.stop()
      else if @properties.mode is "millisecond" and @job
        clearInterval(@job)
      super


module.exports = TimerAdapter
