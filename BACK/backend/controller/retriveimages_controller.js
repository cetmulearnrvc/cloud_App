import express from 'express';
import path from 'path';
import { google } from 'googleapis';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Initialize OAuth2 Client (same as in your upload code)
const oauth2Client = new google.auth.OAuth2(
  process.env.GOOGLE_API_CLIENT_ID,
  process.env.GOOGLE_API_CLIENT_SECRET,
  process.env.GOOGLE_REDIRECT_URI
);
oauth2Client.setCredentials({ refresh_token: process.env.Refresh_Token });
const drive = google.drive({ version: 'v3', auth: oauth2Client });

// Custom middleware to serve files from Google Drive
export async function retriveImg(req, res, next) {
  try {
    const fileName = req.path.substring(1); // Remove leading slash
    
    // Search for file in Google Drive
    const response = await drive.files.list({
      q: `name='${fileName}' and trashed=false`,
      fields: 'files(id, name, webContentLink)',
      spaces: 'drive',
    });

    if (response.data.files.length === 0) {
      return res.status(404).send('File not found');
    }

    const file = response.data.files[0];
    
    // Option 1: Redirect to Google's hosted content link
    return res.redirect(file.webContentLink);
    
    // Option 2: Proxy the file content (if you need to modify or secure access)
    // const fileStream = await drive.files.get({
    //   fileId: file.id,
    //   alt: 'media'
    // }, { responseType: 'stream' });
    // fileStream.data.pipe(res);
    
  } catch (error) {
    console.error('Error serving file:', error);
    res.status(500).send('Error retrieving file');
  }
};