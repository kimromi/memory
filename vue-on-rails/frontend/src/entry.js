import Vue from 'vue';

export default new Vue({
  el: '#vue-hello',
  data: {
    message: 'hello'
  },
  methods: {
    shout: function () {
      this.message = 'hello!!!!!!!!!!!';
    }
  }
});
