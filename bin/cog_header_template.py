[[[cog
import cog
import datetime
now = datetime.datetime.now()
YEAR = str(now.year)
]]]
[[[end]]]
[[[cog 
cog.outl("#ifndef "+FILE_NAME.upper()+"_H \n#define "+FILE_NAME.upper()+"_H")
]]]
[[[end]]]

/**
 * 
 [[[cog 
 cog.outl("* <p>Title:  "+FILE_NAME+" </p>")
 cog.outl("* <p>Description: </p>") 
 cog.outl("* <p>Copyright: Copyright (c) "+YEAR+" "+COMPANY_NAME+" </p>") 
 ]]]
 [[[end]]]
 [[[cog  ]]]
 [[[end]]]
 * 
  [[[cog 
 cog.outl("* <p>Title:  "+FILE_NAME+" </p>")
 cog.outl("* <p>Company: XX</p>") 
 cog.outl("* <p>Copyright: Copyright (c) "+YEAR+" "+COMPANY_NAME+" </p>") 
 ]]]
 [[[end]]]

 
 
 *
 [[[cog
 cog.outl("* @file "+FILE_NAME+".h")
 cog.outl("* @author "+USER_NAME)
 cog.out("* @since "+VERSION_NO) 
 ]]]
 [[[end]]]
 */

[[[cog

cog.outl("class " +FILE_NAME +" {")
cog.outl("public:")
fnames = [FILE_NAME, '~'+FILE_NAME,]
for fn in fnames:
    cog.outl("  %s();" % fn)

cog.outl("};")

cog.outl("#endif")
]]]
[[[end]]]
