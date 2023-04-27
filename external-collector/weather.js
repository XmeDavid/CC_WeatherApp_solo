import fetch from 'node-fetch';

export async function fetchWeatherData(apiKey, apiUrl, cityName) {
    const response = await fetch(`${apiUrl}?q=${cityName}&appid=${apiKey}`);
  
    if (!response.ok) {
        throw new Error('Failed to fetch weather data');
    }

    const data = await response.json();
    return {
        humidity: data.main.humidity,
        temperature: data.main.temp/10,
        windSpeed: data.wind.speed,
        pressure: data.main.pressure,
        windDirection: data.wind.deg,
        location: cityName,
    };
}
