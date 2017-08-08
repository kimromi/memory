var employees = new Vue({
  el: '#vue-employees',
  data: {
    keyword: '',
    employees: [],
  },
  watch: {
    keyword: function() {
      this.search(this.keyword)
    }
  },
  created: function() {
    axios.get('/admin/employees.json').then(function(result) {
      this.employees = result.data.map(function(employee){
        employee.display = true
        return employee
      })
    }.bind(this))
  },
  methods: {
    editUrl: function(id) {
      return `/admin/employees/${id}`
    },
    search: function(keyword){
      let r = new RegExp(this.keyword, 'g')
      this.employees = this.employees.map(function(employee){
        employee.display = !!(employee.email.match(r) || employee.role.match(r))
        return employee
      })
    }
  }
})
