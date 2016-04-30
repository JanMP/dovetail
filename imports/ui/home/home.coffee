{Meteor} = require "meteor/meteor"

#require "/imports/ui/home/home.styl"
require "/imports/ui/home/home.jade"
require "/imports/api/methods.coffee"
{ Bars, Going } = require "/imports/api/collections.coffee"

Template.home.viewmodel
  locationInput : ""
  locationQuery : ""
  submit : (event) ->
    event.preventDefault()
    @locationQuery @locationInput()
    Meteor.call "dovetail.getBars",
      locationQuery : @locationQuery()
  bars : ->
    Bars.find
      searchStrings : @locationQuery()
  gotBars : ->
    Bars.findOne(searchStrings : @locationQuery())?
  autorun : ->
    savedQuery = Meteor.user()?.profile.locationQuery or ""
    @locationInput savedQuery
    @locationQuery savedQuery

Template.barView.viewmodel
  areGoing : ->
    Going.find( yelpId : @yelpId() ).count()
  imGoing : ->
    selector =
      userId : Meteor.userId()
      yelpId : @yelpId()
    Going.findOne(selector)?
  toggleGoing : ->
    console.log "toggleGoing", @yelpId()
    Meteor.call "dovetail.toggleGoing",
      yelpId : @yelpId()
