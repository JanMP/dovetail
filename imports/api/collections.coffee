{ Mongo } = require "meteor/mongo"

Bars = new Mongo.Collection "bars"
Bars.schema = new SimpleSchema
  yelpId :
    type : String
  name :
    type : String
  address :
    type : [String]
    optional : true
  imageUrl :
    type : String
    optional : true
  searchStrings :
    type : [String]
    optional : true
  lastCalled :
    type : Date
Bars.attachSchema Bars.schema
# Bars.helpers
#   goingCount : ->
#     Going.find(yelpId : @yelpId).count()
#   userIsGoing : ->
#     isGoing = Going.findOne
#       userId : Meteor.userId()
#       yelpId : @yelpId
#     isGoing?
exports.Bars = Bars

Going = new Mongo.Collection "going"
Going.schema = new SimpleSchema
  yelpId :
    type : String
  userId :
    type : String
  date :
    type : Date
Going.attachSchema Going.schema
exports.Going = Going
