import fetch from 'node-fetch';


export async function submitData(weatherData, targetServerUrl, retryAttempts) {
    let attempts = 0;
    while (attempts < retryAttempts) {
        try {
            const response = await fetch(targetServerUrl, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(weatherData),
            });
            if (response.ok) {
                break;
            } else {
                throw new Error('Server error');
            }
        } catch (error) {
            attempts++;
            console.error(`[ExternalCollector] Error submitting data: ${error.message}. Retrying...`);
            await new Promise(resolve => setTimeout(resolve, 5000))
        }
    }

    if (attempts === retryAttempts) {
        console.error('[ExternalCollector] All retry attempts failed. Data submission unsuccessful.');
    }
}
