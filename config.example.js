// Configuration Template for DuckHat Panel
// Copy this file to config.js and modify values

module.exports = {
    // Telegram Bot Configuration
    telegram: {
        token: 'YOUR_BOT_TOKEN_HERE',
        chatId: 'YOUR_CHAT_ID_HERE'
    },
    
    // Server Configuration
    server: {
        port: 5000,
        host: '0.0.0.0'
    },
    
    // Security Settings
    security: {
        enableRateLimit: true,
        maxConnections: 100
    }
};
