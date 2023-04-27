const express = require('express')
const bodyParser = require('body-parser')
const axios = require('axios')

const app = express()
app.use(bodyParser.json())

const PORT = process.env.PORT || 4200

const server_url = process.env.SERVER_URL || 'http://example:8080';

const api_url = server_url + '/data';

app.listen(PORT, () => {
    console.log(`Collector API listening on port ${PORT}`)
})


var humidityData = {};
var temperatureData = {};
var windSpeedData = {};
var windDirectionData = {};
var pressureData = {};


const addData = (data, value, location, timestamp) => {
    if (!data[location]) {
        data[location] = { value, timestamp };
    } else if (timestamp > data[location].timestamp) {
        data[location] = { value, timestamp };
    }
};
  
app.post('/weather/humidity', (req, res) => {
    addData(humidityData, req.body.value, req.body.location, req.body.timestamp);
    resJson = { message: 'Humidity data added.' , data: humidityData}
    res.status(201).send(resJson);
    console.log('Received humidity data')
});
  
app.post('/weather/temperature', (req, res) => {
    addData(temperatureData, req.body.value, req.body.location, req.body.timestamp);
    resJson = { message: 'Temperature data added.' , data: temperatureData}
    res.status(201).send(resJson);
    console.log('Received temperature data')
});
  
app.post('/weather/wind-speed', (req, res) => {
    addData(windSpeedData, req.body.value, req.body.location, req.body.timestamp);
    resJson = { message: 'Wind speed data added.' , data: windSpeedData}
    res.status(201).send(resJson);
    console.log('Received wind speed data')
});
  
app.post('/weather/wind-direction', (req, res) => {
    addData(windDirectionData, req.body.value, req.body.location, req.body.timestamp);
    resJson = { message: 'Wind direction data added.' , data: windDirectionData}
    res.status(201).send(resJson);
    console.log('Received wind direction data')
});
  
app.post('/weather/pressure', (req, res) => {
    addData(pressureData, req.body.value, req.body.location, req.body.timestamp);
    resJson = { message: 'Pressure data added.' , data: pressureData}
    res.status(201).send(resJson);
    console.log('Received pressure data')
});
  

const sendAggregatedData = async () => {
    const locations = new Set([
        ...Object.keys(humidityData),
        ...Object.keys(temperatureData),
        ...Object.keys(windSpeedData),
        ...Object.keys(windDirectionData),
        ...Object.keys(pressureData),
    ]);
  
    for (const location of locations) {
        const aggregatedData = {
            humidity: humidityData[location]?.value,
            temperature: temperatureData[location]?.value,
            windSpeed: windSpeedData[location]?.value,
            windDirection: windDirectionData[location]?.value,
            pressure: pressureData[location]?.value,
            location,
      };
  
        try {
            console.log('Sending aggregated data...')
            process.env.NODE_TLS_REJECT_UNAUTHORIZED = '0';
            const response = await axios.post(api_url, aggregatedData);
            console.log('Aggregated data sent successfully:', response.status);
        } catch (error) {
            console.error('Error sending aggregated data:', error);
        }
    }
  
    Object.keys(humidityData).forEach((key) => delete humidityData[key]);
    Object.keys(temperatureData).forEach((key) => delete temperatureData[key]);
    Object.keys(windSpeedData).forEach((key) => delete windSpeedData[key]);
    Object.keys(windDirectionData).forEach((key) => delete windDirectionData[key]);
    Object.keys(pressureData).forEach((key) => delete pressureData[key]);

    humidityData = {};
    temperatureData = {};
    windSpeedData = {};
    windDirectionData = {};
    pressureData = {};
  };



setInterval(sendAggregatedData, 10 * 60 * 1000); // Run every 10 minutes
