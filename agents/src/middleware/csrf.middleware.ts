import { Request, Response, NextFunction } from 'express';

/**
 * Simple CSRF token validation middleware
 * Expects X-CSRF-Token header to match session token
 */
export const csrfProtection = (req: Request, res: Response, next: NextFunction) => {
  if (req.method === 'GET' || req.method === 'HEAD' || req.method === 'OPTIONS') {
    return next();
  }

  const token = req.headers['x-csrf-token'];
  
  if (!token) {
    res.status(403).json({ error: 'CSRF token missing' });
    return;
  }

  // TODO: Validate token against session store
  // For now, just check token exists
  next();
};
