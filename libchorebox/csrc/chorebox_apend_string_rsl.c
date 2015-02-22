// libchorebox - A high-level C programming library for -chorebox-
// chorebox_apend_string_rsl.c - Source-code for this function:
// Copyright (C) 2014  Sophia Elizabeth Shapira
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// ########################

#include <chorebox.h>

bool chorebox_apend_string_rsl ( char **rg_a, char *rg_b )
{
  char *lc_read;
  char *lc_write;
  size_t lc_charcount;
  size_t lc_charbufsz;
  char *lc_buf;
  if ( rg_a == NULL ) { return false; }
  if ( rg_b == NULL ) { return true; }
  
  // Now, we find the size of the added string.
  lc_charcount = 0;
  lc_read = rg_b;
  while ( (*lc_read) != '\0' )
  {
    lc_charcount++;
    lc_read++;
  }
  
  // And if applicable, the size of the pre-existing string.
  lc_read = (*rg_a);
  if ( lc_read != NULL )
  {
    while ( (*lc_read) != '\0' )
    {
      lc_charcount++;
      lc_read++;
    }
  }
  
  // And we add, of course, one more space for the null-terminator.
  lc_charcount++;
  
  // Now we mallocate.
  lc_charbufsz = ( lc_charcount * sizeof(char) );
  lc_buf = malloc(lc_charbufsz);
  if ( lc_buf == NULL ) { return false; }
  lc_write = lc_buf;
  
  // First we add the old string.
  lc_read = (*rg_a);
  if ( lc_read != NULL )
  {
    while ( (*lc_read) != '\0' )
    {
      *lc_write = *lc_read;
      lc_write++;
      lc_read++;
    }
  }
  
  // And we add the new string.
  lc_read = rg_b;
  while ( (*lc_read) != '\0' )
  {
    *lc_write = *lc_read;
    lc_write++;
    lc_read++;
  }
  
  // And we top it off with the null-terminator.
  *lc_write = '\0';
  
  // Now, if there ever was something on the old string, now is
  // the time to free it.
  if ( (*rg_a) == NULL ) { free((*rg_a)); }
  
  // Attach the new string-value -- and exit.
  *rg_a = lc_buf;
  return true;
}

