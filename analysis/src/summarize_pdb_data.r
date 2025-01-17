# Amir Shahmoradi, Thursday 4:20 PM, Aug 21 2014, Wilke Lab, ICMB, UT Austin
# This code summarizes all PDB-level properties of all proteins in the dataset in a long-table format.

#install.packages("reshape2")
#library("reshape2")
#library('corrplot')

setwd('C:/Users/Amir/Documents/GitHub/cordiv/analysis/src')

# source('get_res_data.r') ATTN: don't do this! It will take a few hours to get the data summarized at the pdb level. It has been already sourced and the summary exists in the following file.

pdb_CO = read.table('../../properties/pdb_prop_CO.out',header=T)
pdb_CO$pdb = factor(pdb_CO$pdb)

pdb_prop_dssp = read.table('../../properties/pdb_prop_dssp.out',header=T)
pdb_prop_dssp = cbind( pdb_prop_dssp,
                       data.frame(sum.nhbpa.dif = pdb_prop_dssp$sum.nhbps - pdb_prop_dssp$sum.nhbas),
                       data.frame(mean.nhbpa.dif = pdb_prop_dssp$mean.nhbps - pdb_prop_dssp$mean.nhbas)
                       )
pdb_prop_dssp$pdb = factor(pdb_prop_dssp$pdb)

pdb_temp = cbind( subset(pdb_CO, select = c(pdb,natoms,contact_order,contact_orderSC,contact_orderAA)),
                  subset(pdb_prop_dssp, select = -c(pdb,pdb_asa))
                  )

pdb_prop_dssp_CO_long = reshape( pdb_temp,
                         idvar = 'pdb',
                         varying = names(pdb_temp[,!(names(pdb_temp) %in% 'pdb')]),
                         v.names = 'value',
                         timevar = 'variable',
                         times = names(pdb_temp[,!(names(pdb_temp) %in% 'pdb')]),
                         direction = 'long'
                         )
rownames(pdb_prop_dssp_CO_long) = NULL

# Now combine all PDB data in a single long table:

pdb_prop_from_residue_prop = read.csv('../tables/pdb_prop_from_residue_prop.csv')
all_pdb_prop = rbind(pdb_prop_from_residue_prop,pdb_prop_dssp_CO_long)

write.csv(all_pdb_prop, "../tables/all_pdb_prop.csv", row.names=F )

all_pdb_prop$variable = factor(all_pdb_prop$variable)

variable_counter = 0
all_spcor = data.frame()

for (variable1 in levels(all_pdb_prop$variable))
{
  temp_var1 = all_pdb_prop[all_pdb_prop$variable == variable1,]
  
  var_spcor = data.frame()
  start_time = proc.time()
  for (variable2 in levels(all_pdb_prop$variable))
  {
    if (variable1 != variable2)
    {
      temp_var2 = all_pdb_prop[all_pdb_prop$variable == variable2,]
      x = cor.test( temp_var1$value, temp_var2$value, method='spearman', na.action="na.omit" )
      r = x$estimate
      p = x$p.value
      
      row = data.frame( var1 = variable1,
                        var2 = variable2,
                        abs.spearman.r = abs(r),
                        spearman.r = r,
                        spearman.p = p
                        )
      
      var_spcor = rbind(var_spcor,row)
    }
  }
  
  var_spcor_ordered = var_spcor[with(var_spcor, order(-abs.spearman.r)),]
  
  filename = paste0( '../tables/correlations/',variable1,'.csv' )
  write.csv( var_spcor_ordered, file = filename, row.names=F )
  
  all_spcor = rbind (all_spcor, var_spcor_ordered)
  
  variable_counter = variable_counter + 1
  cat(variable_counter, variable1, nrow(temp_var1), 'time taken: ', proc.time()-start_time, '\n')
  
}

write.csv( all_spcor, file = '../tables/correlations/all_correlations.csv', row.names=F )
