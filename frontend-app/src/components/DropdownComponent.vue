<template>
    <select @change="onTypeChange">
      <option v-for="location in locations" :key="location" :value="location">{{ location }}</option>
    </select>
  </template>
  
  <script>
  export default {
    name: 'DropdownComponent',
    props: {
      locations: {
        type: Array,
        default: () => []
      }
    },
    methods: {
      onTypeChange(event) {
        this.$emit('filter', event.target.value);
      }
    }
  };
  </script>
  