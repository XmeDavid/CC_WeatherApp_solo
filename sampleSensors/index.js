const axios = require('axios');

const collectorApiUrl = 'https://collector-wczredvtgq-uc.a.run.app'
//const collectorApiUrl = 'http://localhost:4200'

// Define the API endpoints
const endpoints = [
  { name: 'humidity', url: collectorApiUrl + '/weather/humidity' },
  { name: 'temperature', url: collectorApiUrl + '/weather/temperature' },
  { name: 'wind-speed', url: collectorApiUrl + '/weather/wind-speed' },
  { name: 'wind-direction', url: collectorApiUrl + '/weather/wind-direction' },
  { name: 'pressure', url: collectorApiUrl + '/weather/pressure' },
];

// Define the locations and number of sensors at each location
const locations = [
  { name: 'New York', sensors: 7 },
  { name: 'London', sensors: 5 },
  { name: 'Tokyo', sensors: 3 },
];

// Send random data to the API endpoints for each location and sensor
//For every location, for every sensor, send a random value to a random endpoint
const sendSampleData = async () => {
  locations.forEach(async (location) => {
  for (let i = 1; i <= location.sensors; i++) {
    const data = {
      value: Math.random() * 100,
      location: location.name,
      timestamp: new Date().toISOString(),
    };
    const endpoint = endpoints[Math.floor(Math.random() * endpoints.length)];
    console.log(`Sending data to ${endpoint.name} endpoint:`, data);
    try {
      const response = await axios.post(endpoint.url, data);
      if(response.status !== 201) throw new Error(response.status)
      console.log(`Data sent successfully to ${endpoint.name}[${endpoint.url}] endpoint:`, response.data);
    } catch (error) {
      console.error(`Error sending data to ${endpoint.name}[${endpoint.url}] endpoint:`, error.message);
    }
  }
});
}

sendSampleData()

setInterval(sendSampleData, 2 * 60 * 1000);