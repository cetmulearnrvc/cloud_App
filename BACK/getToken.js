import { google } from 'googleapis';
import express from 'express';
import open from 'open'; // Modern replacement for 'opn'
import dotenv from 'dotenv'

dotenv.config();

const app = express();
const PORT = 3000;

const REDIRECT_URI = 'http://localhost:3000/auth/callback';

const oauth2Client = new google.auth.OAuth2(
  process.env.GOOGLE_API_CLIENT_ID,
  process.env.GOOGLE_API_CLIENT_SECRET,
  REDIRECT_URI
);

// Generate auth URL
const authUrl = oauth2Client.generateAuthUrl({
  access_type: 'offline', // Required for refresh token
  scope: ['https://www.googleapis.com/auth/drive'],
});

console.log('Authorize this app by visiting:', authUrl);
open(authUrl); // Opens browser for authorization

// Handle callback
app.get('/auth/callback', async (req, res) => {
  const { code } = req.query;
  const { tokens } = await oauth2Client.getToken(code);
  
  console.log('Refresh Token:', tokens.refresh_token); // ✅ SAVE THIS!
  res.send('Authentication successful! You can close this window.');
  process.exit();
});

app.listen(PORT, () => console.log(`Server running on http://localhost:${PORT}`));