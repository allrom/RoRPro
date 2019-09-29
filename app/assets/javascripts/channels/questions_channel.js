$(document).on('turbolinks:load', function() {
    App.cable.subscriptions.create('QuestionsChannel', {

        connected: function () {
            //console.log('Connected to Ques stream...');
            return this.perform('follow');
        },

        disconnected: function () {
            //console.log('Terminated Ques stream...');
            return this.perform('unfollow');
        },

        received: function(data) {
            var question = $.parseJSON(data);
            if (gon.user_id == question.user_id) {
                return;
            }
            //console.log('Added question in stream...');
            return $("#questions-table").append(JST["templates/question"]({ object: question }));
        }
    });
});
