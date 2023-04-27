<template>
  <table>
    <thead>
      <tr>
        <th>Location</th>
        <th>Last Updated</th>
        <th>Temperature</th>
        <th>Humidity</th>
        <th>Wind Speed</th>
        <th>Wind Direction</th>
        <th>Pressure</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="item in data" :key="item.id">
        <td>{{ item.location }}</td>
        <td>{{ item.timestamp }}</td>
        <td>{{ item.temperature }}</td>
        <td>{{ item.humidity }}</td>
        <td>{{ item.windSpeed }}</td>
        <td>{{ item.windDirection }}</td>
        <td>{{ item.pressure }}</td>
      </tr>
    </tbody>
  </table>
</template>


<script>
export default {
  name: 'TableComponent',
  props: {
    data: {
      type: Array,
      default: () => []
    }
  }
};
</script>
