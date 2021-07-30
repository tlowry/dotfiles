[[[cog
import cog
import datetime
now = datetime.datetime.now()
YEAR = str(now.year)
]]]
[[[end]]]
[[[cog 
cog.outl("#ifndef "+FILE_NAME.upper()+"_CPP \n#define "+FILE_NAME.upper()+"_CPP")
cog.outl("#include \""+FILE_NAME+".h\"")
]]]
[[[end]]]

/**
 * 
 [[[cog
 cog.outl("* <p>Title:  "+FILE_NAME+" </p>")
 cog.outl("* <p>Description: </p>") 
 ]]]
 [[[end]]]
 [[[cog  ]]]
 [[[end]]]
 * 
 [[[cog
 cog.outl("* <p>Company: "+COMPANY_NAME+" </p>")
 ]]]
 [[[end]]]
 *
 [[[cog
 cog.outl("* @file "+FILE_NAME+".cpp")
 cog.outl("* @author "+USER_NAME)
 cog.out("* @since "+VERSION_NO) 
 ]]]
 [[[end]]]
 */

[[[cog
fnames = [FILE_NAME, '~'+FILE_NAME]
for fn in fnames:
    cog.outl(FILE_NAME+"::%s(){" % fn)
    cog.outl("}")


cog.outl("#endif")
]]]
[[[end]]]
