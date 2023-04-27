import dotenv from 'dotenv';
import { fetchWeatherData } from './weather.js';
import { submitData } from './submit.js';

console.log('[ExternalCollector] Starting...')

dotenv.config();

const apiKey = process.env.WEATHER_API_KEY;
const apiUrl = process.env.WEATHER_API_URL;
const targetServerUrl = process.env.TARGET_SERVER_URL + "/data";
const retryAttempts = 3
const cities = ['leiria','lisbon','paris'];

const getWeather = async (city) => {
    console.log('[ExternalCollector] Fetching weather data...');
    try {
        const weatherData = await fetchWeatherData(apiKey, apiUrl, city);
        console.log('[ExternalCollector] Weather data fetched successfully.');
        
        console.log('[ExternalCollector] Submitting data to the server...');
        await submitData(weatherData, targetServerUrl, retryAttempts);
        console.log('[ExternalCollector] Data submitted successfully.');
    } catch (error) {
        console.error(`[ExternalCollector] Error: ${error.message}`);
    }
}

const main = async function run() {
    for (const cityName of cities) {
      await getWeather(cityName);
    }
}

await main()
console.log('[ExternalCollector] Finished.')
process.exit(0)