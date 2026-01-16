#!/usr/bin/env node
/**
 * Supabase JWT Key Generator
 *
 * Usage:
 *   JWT_SECRET=your-secret node generate-jwt.js
 *
 * Or set JWT_SECRET in .env and run:
 *   node generate-jwt.js
 */

const crypto = require('crypto');

const JWT_SECRET = process.env.JWT_SECRET;

if (!JWT_SECRET) {
  console.error('ERROR: JWT_SECRET environment variable is required');
  console.error('Usage: JWT_SECRET=your-secret node generate-jwt.js');
  process.exit(1);
}

if (JWT_SECRET.length < 32) {
  console.error('ERROR: JWT_SECRET must be at least 32 characters');
  process.exit(1);
}

function base64url(source) {
  return Buffer.from(source)
    .toString('base64')
    .replace(/=/g, '')
    .replace(/\+/g, '-')
    .replace(/\//g, '_');
}

function createJWT(payload, secret) {
  const header = { alg: 'HS256', typ: 'JWT' };
  const headerB64 = base64url(JSON.stringify(header));
  const payloadB64 = base64url(JSON.stringify(payload));
  const signature = crypto
    .createHmac('sha256', secret)
    .update(`${headerB64}.${payloadB64}`)
    .digest('base64')
    .replace(/=/g, '')
    .replace(/\+/g, '-')
    .replace(/\//g, '_');
  return `${headerB64}.${payloadB64}.${signature}`;
}

// Generate keys with 10 year expiry
const iat = Math.floor(Date.now() / 1000);
const exp = iat + (10 * 365 * 24 * 60 * 60); // 10 years

const anonKey = createJWT({
  iss: 'supabase',
  role: 'anon',
  iat: iat,
  exp: exp
}, JWT_SECRET);

const serviceRoleKey = createJWT({
  iss: 'supabase',
  role: 'service_role',
  iat: iat,
  exp: exp
}, JWT_SECRET);

console.log('# Generated JWT Keys');
console.log('# Issued at:', new Date(iat * 1000).toISOString());
console.log('# Expires at:', new Date(exp * 1000).toISOString());
console.log('');
console.log('ANON_KEY=' + anonKey);
console.log('');
console.log('SERVICE_ROLE_KEY=' + serviceRoleKey);
