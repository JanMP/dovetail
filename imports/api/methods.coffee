
{ Bars, Going } = require "/imports/api/collections.coffee"

exports.toggleGoing = new ValidatedMethod
  name : "dovetail.toggleGoing"
  validate : new SimpleSchema
    yelpId :
      type : String
  .validator()
  run : ({yelpId}) ->
    unless @userId?
      throw new Meteor.Error "dovetail.going unauthorized",
      "only logged in users may go to bars"
    selector =
      yelpId : yelpId
      userId : @userId
    going = Going.findOne selector
    if going?
      Going.remove selector
    else
      selector.date = new Date()
      Going.insert selector

exports.saveLocation = new ValidatedMethod
  name : "dovetail.saveLocation"
  validate : new SimpleSchema
    locationQuery :
      type : String
  .validator()
  run : ({locationQuery}) ->
    unless @userId
      throw new Meteor.Error "dovetail.saveLocation unauthorized",
      "only logged in users can save the location to the db"
    Meteor.users.update @userId,
      $set :
        profile :
          locationQuery : locationQuery
