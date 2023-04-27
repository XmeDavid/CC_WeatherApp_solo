<template>
  <div id="app">
    Location
    <DropdownComponent :locations="locations" @filter="filterTable" />
    <TableComponent :data="filteredData" />
  </div>
</template>

<script>
import TableComponent from './components/TableComponent.vue';
import DropdownComponent from './components/DropdownComponent.vue';

export default {
  name: 'App',
  components: {
    TableComponent,
    DropdownComponent
  },
  data() {
    return {
      rawData: [],
      filteredData: [],
      locations: []
    };
  },
  async created() {
    const server_url = process.env.VUE_APP_TARGET_SERVER_URL + '/data';
    console.log(server_url)
    const response = await fetch(server_url);
    this.rawData = await response.json();
    console.log(this.rawData)
    this.rawData = this.rawData.map(item => {
      let obj = JSON.parse(item.content)
      obj.timestamp = item.createdAt
      return obj
    });
    this.rawData = this.rawData.map(item => {
      if (!Object.prototype.hasOwnProperty.call(item, 'location')) {
        item.location = 'unknown';
      }
      return item;
    });

    this.locations = [...new Set(['All',...this.rawData.map(item => item.location)])];
    this.filteredData = this.rawData;
  },
  methods: {
    filterTable(location) {
      if (location === 'All') {
        this.filteredData = this.rawData;
      } else {
        this.filteredData = this.rawData.filter(item => item.location === location);
      }
    }
  }
};
</script>
