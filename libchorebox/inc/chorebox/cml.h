

#ifndef L__CHOREBOX_CML__H
#define L__CHOREBOX_CML__H
#include <chorebox.h>
#include <stdbool.h>

// This is the header file for the CML sub-section of
// the chorebox library. It is designed to make it easier
// to process the command-line and arrays with similar
// information. It is implemented via Chorebox's Object
// Oriented Convention -- yes - that's the same convention
// for which there will *eventually* be a transpiler
// implemented to make it easier to use. However - in
// the mean time, it can still be used in C. (The
// convention's own documentation, once written, will
// go into more detail on everything - including how
// it is possible to use even in C and what minor
// inconveniences not *yet* having the transpiler
// entails.)


typedef bool (*chorebox_cml__xcrs) ( void *rg_a );
// This defines a pointer-type to the kind of function that
// can be used as a CRS option handler-function. The argument
// is of type 'void *' - but would have been of type
// 'chorebox_cml__hnd' if it weren't for C's vulnerability
// to the chicken-egg dilemma on this matter - and therefore
// should be cast as such in the function's code before
// it is used in functions. It is the handle to the object
// that it should draw arguments from if necessary.
//   The reason why option handler-functions require a handle
// to the object is just in case an option requires an
// argument beyond the one in which the option is named.
// Of course, for this reason, all option handlers must
// accept the object handle - even those that don't use
// it.

// The difference between a CRS option-handler and a
// BLN option handler (CRS is short for 'crisp' and
// BLN is short for 'blending') is that with a CRS
// option, the option-name takes up an entire argument
// - and any argument to the CRS option will take up
// further arguments. A BLN option handler, on the
// other hand is a bit more complex. In a BLN option,
// the option-name is only the *beginning* of the
// argument -- and a char-pointer to whatever *remains*
// 

typedef struct chorebox_cml__cls {
  
  void (*m_close) ( void *rgo_a );
  // This method closes the object, frees up all it's
  // dedicated resources and sets the pointer that the
  // object-handle references to NULL.
  //   This method will not return in failure - and
  // will terminate the program if that is the only
  // way to prevent it.
  
  bool (*m_ismort) ( void *rgo_a );
  // This method returns 'true' if the object is in mortal
  // mode (which is the default mode of the object type)
  // and 'false' if it is in resilient mode (an
  // alternative that may or may-not be available in
  // some classes of this class-type).
  //   The distinction between the two modes is that
  // there are some methods that will terminate the
  // program upon failure rather than return to the
  // calling program if the object is in mortal mode
  // - but which may return in a specified manner
  // even upon failure if the object is in resilient
  // mode.
  
  bool (*m_setmort) ( void *rgo_a, bool rg_a );
  // Attempts to set the object to mortal mode if
  // rg_a is 'true' and to resilient mode if rg_a
  // is 'false'.
  //   Upon success (and this method should be
  // written to always succeed if the class is
  // implemented in a way that makes resilient mode
  // available) this method will return 'true'.
  //   On the other hand, if this class is implemented
  // in a manner that does *not* allow for resilient
  // mode, this method will do nothing at all - and
  // it will return false.
  //   So if you want to query whether or not this
  // class has resilient mode available, simply
  // call this method with the return-value from
  // the 'ismort' method.
  //   It should be noted that the flagship class
  // of this class-type does *not* allow for
  // resilient mode - yet there may be other
  // classes of this class-type that do.
  
  bool (*m_opt) ( void *rgo_a, char *rg_a, chorebox_cml__xcrs rg_b );
  // This method adds a CRS option to the
  
} chorebox_cml__cls;

typedef struct chorebox_cml__obj {
  chorebox_cml__cls *cls;
  void *prv; // Private parts - specific to a class's implementation.
} chorebox_cml__obj;
typedef chorebox_cml__obj *chorebox_cml__ptr;
typedef chorebox_cml__ptr *chorebox_cml__hnd;

#endif
