class Worksummarizer.Models.Ticket extends Backbone.Model
    paramRoot: 'ticket'

class Worksummarizer.Collections.TicketsCollection extends Backbone.Collection
    model: Worksummarizer.Models.Ticket
    url: '/home/tickets'
    comparator: (item) ->
      item.get 'assigned_to_id'
