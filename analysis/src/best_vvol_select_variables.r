# This code is aimed at finding which definition of Voronoi cell volumes (vvol) can best represent a residue. This is done by comparing the correlations of different vvols with other residue variables.
# "select_variables" in the name of this code refers to the fact that I am comparing the performance of different vvols to only a select number of important residue properties, such as ASA, RSA, seqent, ddGent, and I am ignoring the rest which are generally definition dependent, such as different definitions of B factors and WCN based on the set of atom coordinates used.

# Last updated by Amir Shahmoradi, Friday 1:23 PM, October 4 2014, Wilke Lab, ICMB, UT Austin

# Input data:
#               ../../elj_pdb_entropies.in
#               ../../properties/res_prop_hps.out
#               ../../properties/res_prop_dssp.out
#               ../../properties/res_prop_wcn_bf.out
#               ../../properties/res_prop_voronoiAA.out
#               ../../properties/res_prop_voronoiCA.out
#               ../../properties/res_prop_voronoiSC.out

#install.packages("reshape2")
#library("reshape2")
#library('corrplot')

# setwd('C:/Users/Amir/Documents/GitHub/cordiv/analysis/src')
# 
# excluded_pdbs = c('1BBS_A','1BS0_A','1DIN_A','1HPL_A')   # These are the 4 PDBs that did not have complete r4s evolutionary rates and are omitted from the dataset to avoid NA values.
# npdbs = 209         # number of pdb structures in the dataset
# 
# res_prop_jec         = read.csv('../../jec_pdb_r4s.csv', header=T)
# res_prop_jec         = res_prop_jec[!(res_prop_jec$pdb %in% excluded_pdbs),]
# res_prop_jec$pdb     = factor(res_prop_jec$pdb)
# 
# res_prop_elj         = read.table('../../elj_pdb_entropies.in', header=T)
# res_prop_elj         = res_prop_elj[!(res_prop_elj$pdb %in% excluded_pdbs),]
# res_prop_elj$pdb     = factor(res_prop_elj$pdb)
# 
# res_prop_hps         = read.table('../../properties/res_prop_hps.out', header=T)
# res_prop_hps         = res_prop_hps[!(res_prop_hps$pdb %in% excluded_pdbs),]
# res_prop_hps$pdb     = factor(res_prop_hps$pdb)
# 
# res_prop_dssp        = read.table('../../properties/res_prop_dssp.out', header=T)
# res_prop_dssp        = res_prop_dssp[!(res_prop_dssp$pdb %in% excluded_pdbs),]
# res_prop_dssp$pdb    = factor(res_prop_dssp$pdb)
# 
# res_prop_wcn_bf      = read.table('../../properties/res_prop_wcn_bf.out', header=T)
# res_prop_wcn_bf      = res_prop_wcn_bf[!(res_prop_wcn_bf$pdb %in% excluded_pdbs),]
# res_prop_wcn_bf$pdb  = factor(res_prop_wcn_bf$pdb)
# 
# res_prop_voroAA      = read.table('../../properties/res_prop_voronoiAA.out', header=T)
# res_prop_voroAA      = res_prop_voroAA[!(res_prop_voroAA$pdb %in% excluded_pdbs),]
# res_prop_voroAA$pdb  = factor(res_prop_voroAA$pdb)
# res_prop_voroAA      = cbind(res_prop_voroAA, VAAmodified_volume_diff = res_prop_voroAA$VAAvolume, VAAmodified_volume_ratio = res_prop_voroAA$VAAvolume)
# maxval = max(res_prop_voroAA$VAAvolume)
# res_prop_voroAA$VAAmodified_volume_diff[res_prop_voroAA$VAAvolume_change_diff != 0] = maxval
# res_prop_voroAA$VAAmodified_volume_diff  = res_prop_voroAA$VAAmodified_volume_diff + res_prop_voroAA$VAAvolume_change_diff
# res_prop_voroAA$VAAmodified_volume_ratio[res_prop_voroAA$VAAvolume_change_ratio != 1] = maxval
# res_prop_voroAA$VAAmodified_volume_ratio = res_prop_voroAA$VAAmodified_volume_ratio * res_prop_voroAA$VAAvolume_change_ratio
# 
# res_prop_voroCA      = read.table('../../properties/res_prop_voronoiCA.out', header=T)
# res_prop_voroCA      = res_prop_voroCA[!(res_prop_voroCA$pdb %in% excluded_pdbs),]
# res_prop_voroCA$pdb  = factor(res_prop_voroCA$pdb)
# res_prop_voroCA      = cbind(res_prop_voroCA, VCAmodified_volume_diff = res_prop_voroCA$VCAvolume, VCAmodified_volume_ratio = res_prop_voroCA$VCAvolume)
# maxval = max(res_prop_voroCA$VCAvolume)
# res_prop_voroCA$VCAmodified_volume_diff[res_prop_voroCA$VCAvolume_change_diff != 0] = maxval
# res_prop_voroCA$VCAmodified_volume_diff  = res_prop_voroCA$VCAmodified_volume_diff + res_prop_voroCA$VCAvolume_change_diff
# res_prop_voroCA$VCAmodified_volume_ratio[res_prop_voroCA$VCAvolume_change_ratio != 1] = maxval
# res_prop_voroCA$VCAmodified_volume_ratio = res_prop_voroCA$VCAmodified_volume_ratio * res_prop_voroCA$VCAvolume_change_ratio
# 
# res_prop_voroSC      = read.table('../../properties/res_prop_voronoiSC.out', header=T)
# res_prop_voroSC      = res_prop_voroSC[!(res_prop_voroSC$pdb %in% excluded_pdbs),]
# res_prop_voroSC$pdb  = factor(res_prop_voroSC$pdb)
# res_prop_voroSC      = cbind(res_prop_voroSC, VSCmodified_volume_diff = res_prop_voroSC$VSCvolume, VSCmodified_volume_ratio = res_prop_voroSC$VSCvolume)
# maxval = max(res_prop_voroSC$VSCvolume)
# res_prop_voroSC$VSCmodified_volume_diff[res_prop_voroSC$VSCvolume_change_diff != 0] = maxval
# res_prop_voroSC$VSCmodified_volume_diff  = res_prop_voroSC$VSCmodified_volume_diff + res_prop_voroSC$VSCvolume_change_diff
# res_prop_voroSC$VSCmodified_volume_ratio[res_prop_voroSC$VSCvolume_change_ratio != 1] = maxval
# res_prop_voroSC$VSCmodified_volume_ratio = res_prop_voroSC$VSCmodified_volume_ratio * res_prop_voroSC$VSCvolume_change_ratio

vvol_scors_all_pdbs = data.frame()    # This dataframe will contain the mean median and variance of sequqence entropy and ddG Rate for each pdb file.
vvol_list = c('vSC','vAA','vCA','mvSC','mvAA','mvCA','fvSC','fvAA','fvCA')
vvol_list_long = c('VSCvolume','VAAvolume','VCAvolume','VSCmodified_volume_ratio','VAAmodified_volume_ratio','VCAmodified_volume_ratio','VSCfree_volume','VAAfree_volume','VCAfree_volume')
counter = 0

for(pdb in levels(res_prop_elj$pdb))
{
  counter = counter + 1
  cat( paste(str(counter),pdb) )
  
  pdb_jec    = res_prop_jec[res_prop_jec$pdb==pdb,] # c('r4sJC')]  
  pdb_elj    = res_prop_elj[res_prop_elj$pdb==pdb,] # c('seqent','ddgent')]
  pdb_hps    = res_prop_hps[res_prop_hps$pdb==pdb,]  # c('hpskd','hpsww','hpshh')]
  pdb_dssp   = res_prop_dssp[res_prop_dssp$pdb==pdb,] # c('asa','rsa','hbe','rss')] )
  #pdb_bf     = res_prop_wcn_bf[res_prop_wcn_bf$pdb==pdb]
  #pdb_wcn    = res_prop_wcn_bf[res_prop_wcn_bf$pdb==pdb]
  #pdb_voroAA = res_prop_voroAA[res_prop_voroAA$pdb==pdb, ]
  #pdb_voroCA = res_prop_voroCA[res_prop_voroCA$pdb==pdb, ]
  #pdb_voroSC = res_prop_voroSC[res_prop_voroSC$pdb==pdb, ]
  pdb_voro = cbind(res_prop_voroAA[res_prop_voroAA$pdb==pdb, c('VAAvolume','VAAmodified_volume_ratio','VAAfree_volume')],
                   res_prop_voroCA[res_prop_voroCA$pdb==pdb, c('VCAvolume','VCAmodified_volume_ratio','VCAfree_volume')],
                   res_prop_voroSC[res_prop_voroSC$pdb==pdb, c('VSCvolume','VSCmodified_volume_ratio','VSCfree_volume')])
  pdb_voro = pdb_voro[, vvol_list_long]
  colnames(pdb_voro) = vvol_list
  
  pdb_temp = cbind( subset(pdb_jec, select = c(r4s_JC)),
                    subset(pdb_elj, select = c(seqent,ddgent)),
                    subset(pdb_hps, select  = c(hpshh)),
                    subset(pdb_dssp, select = c(rsa,hbe)),
                    #subset(pdb_dssp, select = c(asa,rsa,hbe)),
                    data.frame( resvol = res_prop_voroAA[res_prop_voroAA$pdb==pdb, c('resvol')] )
                    #subset(pdb_wcn, select = -c(pdb,resnam,resnum,bfSC,bfAA,bfN,bfCA,bfC,bfO,bfCB)),
                    #subset(pdb_voroAA, select = c(VAAvolume,VAAmodified_volume,VAAfree_volume)),
                    #subset(pdb_voroCA, select = -c(pdb,resnam,resnum,sizeSC,sizeAA,resvol,VCAnvertices,VCAnedges,VCAvolume_change)),
                    #subset(pdb_voroSC, select = -c(pdb,resnam,resnum,sizeSC,sizeAA,resvol,VSCnvertices,VSCnedges,VSCvolume_change))
                    )
  
  pdb_vvol_long = reshape(pdb_voro, ids = rownames(pdb_voro), varying = colnames(pdb_voro), v.names = 'value', timevar = 'variable', times = colnames(pdb_voro), direction = 'long')
  pdb_vvol_long$variable = factor(pdb_vvol_long$variable)
  pdb_long = reshape(pdb_temp, ids = rownames(pdb_temp), varying = colnames(pdb_temp), v.names = 'value', timevar = 'variable', times = colnames(pdb_temp), direction = 'long')
  pdb_long$variable = factor(pdb_long$variable)
  
  for (vvol in levels(pdb_vvol_long$variable))
  {
    vvol_data = pdb_vvol_long[pdb_vvol_long$variable == vvol,]
    for (variable in levels(pdb_long$variable))
    {
      variable_data = pdb_long[pdb_long$variable == variable,]
      x = cor.test( vvol_data$value, variable_data$value, method='spearman', na.action="na.omit" )
      r = x$estimate
      p = x$p.value
      
      row = data.frame(pdb = pdb, vvol = vvol, variable = variable, value = r)
      vvol_scors_all_pdbs = rbind(vvol_scors_all_pdbs,row)
    }
  }
}
write.csv( vvol_scors_all_pdbs, "../tables/best_vvol/select_variables/vvol_scors_all_pdbs.csv", row.names=F )



# Now summarize all Spearman correlations over the entire dataset

vvol_scors_all_pdbs = read.csv( "../tables/best_vvol/select_variables/vvol_scors_all_pdbs.csv", header = TRUE )
vvol_scors_all_pdbs$variable = factor(vvol_scors_all_pdbs$variable)
vvol_scors_all_pdbs$vvol = factor(vvol_scors_all_pdbs$vvol)


for (vvol in levels(vvol_scors_all_pdbs$vvol))
{
  temp_data_vvol = vvol_scors_all_pdbs[vvol_scors_all_pdbs$vvol == vvol,]
  temp_data_vvol$variable = factor(temp_data_vvol$variable)
  
  vvol_scors_summary = data.frame()
  for (variable in levels(temp_data_vvol$variable))
  {
    temp_data = temp_data_vvol[temp_data_vvol$variable == variable,]
    if (length(temp_data$pdb) != npdbs)
    {
      stop ( 'something is fishy here!' )
    }
    
    x   = quantile(temp_data$value, probs = c(0,0.25,0.5,0.75, 1.))
    row = data.frame(variable = variable,
                     mean     = mean(temp_data$value),
                     median   = x[3],
                     sd       = sd(temp_data$value),
                     min      = x[1],
                     q1       = x[2],
                     q3       = x[4],
                     max      = x[5]
                    )
    vvol_scors_summary = rbind(vvol_scors_summary,row)
  }
  row.names(vvol_scors_summary) = c()
  filename = paste0("../tables/best_vvol/select_variables/",vvol,'_scors_summary.csv')
  write.csv(vvol_scors_summary, filename, row.names=F )
  cat (vvol, filename, '\n')
}

# Now compare the three vvol scors with each other:

for (i in 1:(length(vvol_list)-1))
{
  filename = paste0("../tables/best_vvol/select_variables/",vvol_list[[i]][1],'_scors_summary.csv')
  vvol_scors_summary1 = read.csv( filename, header = T )
  for (j in (i+1):length(vvol_list))
  {
    filename = paste0("../tables/best_vvol/select_variables/",vvol_list[[j]][1],'_scors_summary.csv')
    vvol_scors_summary2 = read.csv( filename, header = T )
    difference = data.frame(variable      = vvol_scors_summary1$variable,
                            mean_diff     = abs(vvol_scors_summary1$mean)   - abs(vvol_scors_summary2$mean),
                            median_diff   = abs(vvol_scors_summary1$median) - abs(vvol_scors_summary2$median),
                            sd_diff       = abs(vvol_scors_summary1$sd)     - abs(vvol_scors_summary2$sd),
                            min_diff      = abs(vvol_scors_summary1$min)    - abs(vvol_scors_summary2$min),
                            q1_diff       = abs(vvol_scors_summary1$q1)     - abs(vvol_scors_summary2$q1),
                            q3_diff       = abs(vvol_scors_summary1$q3)     - abs(vvol_scors_summary2$q3),
                            max_diff      = abs(vvol_scors_summary1$max)    - abs(vvol_scors_summary2$max)
                            )
    row.names(difference) = c()
    filename = paste0('../tables/best_vvol/select_variables/diff_',vvol_list[[i]][1],'_',vvol_list[[j]][1],'.csv')
    cat (filename, '\n')
    write.csv( difference, filename, row.names=F )
  }
}

# Make plots of ABS(vvol) vs. ABS(vvol) for comparison:

x = -2:2
colors = c('red', 'blue', 'green', 'purple', 'orange3', 'darkgreen', 'black', 'gray', 'cyan2') #, 'darkred', 'darkgreen', 'bisque2')
#labels = c('ASA', 'ddG Rate', 'H-bond energy', 'Hydrophobicity', 'Residue Volume', 'RSA', 'Seq. Entropy')
labels = c('ddG Rate', 'H-bond energy', 'Hydrophobicity', 'Evol. Rates', 'Residue Volume', 'RSA', 'Seq. Entropy')

for (i in 1:(length(vvol_list)-1))
{
  filename = paste0("../tables/best_vvol/select_variables/",vvol_list[[i]][1],'_scors_summary.csv')
  vvol_scors_summary1 = read.csv( filename, header = T )
  for (j in (i+1):length(vvol_list))
  {
    filename = paste0("../tables/best_vvol/select_variables/",vvol_list[[j]][1],'_scors_summary.csv')
    vvol_scors_summary2 = read.csv( filename, header = T )
    filename = paste0('../figures/best_vvol/select_variables/abs(',vvol_list[[i]][1],'_',vvol_list[[j]][1],').pdf')
    cat (filename, '\n')
    pdf( filename, width=4.5, height=4, useDingbats=FALSE )
    par( mai=c(0.65, 0.65, 0.1, 0.05), mgp=c(2, 0.5, 0), tck=-0.03 )
    plot(-999,
         #xaxt='n',yaxt='n',bty='n',pch='',
    #plot(abs(vvol_scors_summary1$median),
    #     abs(vvol_scors_summary2$median),
         xlab = paste0( 'absolute median correlation with ',vvol_list[[i]][1] ),
         ylab = paste0( 'absolute median correlation with ',vvol_list[[j]][1] ),
         xlim = c(0,1.0),
         ylim = c(0,1.0)
         )
    points( abs(vvol_scors_summary1$median),
            abs(vvol_scors_summary2$median), pch=19, col=colors[1:length(vvol_scors_summary2$median)])
    lines( x, x, col='red' )
    legend( -0.02, 1.05, labels[1:7], pch=19, col=colors[1:7], bty='n', cex=0.9)
    #legend( 0.7, 0.1, labels[4:6], pch=19, col=colors[4:6], bty='n', cex=0.9)
    graphics.off()
  }
}

# Now create box plots

vvol_scors_all_pdbs = read.csv( "../tables/best_vvol/select_variables/vvol_scors_all_pdbs.csv", header = TRUE )
vvol_scors_all_pdbs$variable = factor(vvol_scors_all_pdbs$variable)
vvol_scors_all_pdbs$vvol = factor(vvol_scors_all_pdbs$vvol)

#variable_list = c('ASA', 'ddG Rate', 'H-bond energy', 'Hydrophobicity', 'Residue Volume', 'RSA', 'Seq. Entropy')
variable_list = c('ddG Rate', 'H-bond energy', 'Hydrophobicity', 'Evol. Rates', 'Residue Volume', 'RSA', 'Seq. Entropy')
vvol_list = c('vSC','vAA','vCA','mvSC','mvAA','mvCA','fvSC','fvAA','fvCA')
counter = 0
for (variable in levels(vvol_scors_all_pdbs$variable))
{ 
  counter = counter + 1
  temp_data_variable_long = vvol_scors_all_pdbs[vvol_scors_all_pdbs$variable == variable,c('pdb','vvol','value')]
  temp_data_variable = reshape(temp_data_variable_long, timevar = 'vvol', idvar = 'pdb', direction = 'wide')
  temp_data_variable = subset (temp_data_variable, select = -c(pdb))
  colnames(temp_data_variable) = levels(vvol_scors_all_pdbs$vvol)
  temp_data_variable = temp_data_variable[vvol_list]
  filename = paste0('../figures/best_vvol/select_variables/boxplot_',variable,'.pdf')
  pdf( filename, width=8, height=4, useDingbats=FALSE )
  par( mai=c(0.65, 0.65, 0.1, 0.05), mgp=c(2, 0.5, 0), tck=-0.03 )
  boxplot(temp_data_variable,
          xlab = 'representative Voronoi cell volume (vvol)',
          ylab = paste0('Spearman correlation with ',variable_list[[counter]][1])
  )
  graphics.off()
}

# Now create box plots all-in-one

vvol_scors_all_pdbs = read.csv( "../tables/best_vvol/select_variables/vvol_scors_all_pdbs.csv", header = TRUE )
vvol_scors_all_pdbs$variable = factor(vvol_scors_all_pdbs$variable)
vvol_scors_all_pdbs$vvol = factor(vvol_scors_all_pdbs$vvol)

#variable_list = c('Sequence Entropy','ddG Rate','RSA','Hydrophobicity','H-bond Energy','Residue Volume')
#variable_names = c('seqent','ddgent','rsa','hpshh','hbe','resvol')
variable_list = c('Evol. Rates','Seq. Entropy','ddG Rate','RSA','Hydrophobicity','H-bond Energy')
variable_names = c('r4s_JC','seqent','ddgent','rsa','hpshh','hbe')
vvol_list = c('vSC','vAA','vCA','mvSC','mvAA','mvCA','fvSC','fvAA','fvCA')
filename = paste0('../figures/best_vvol/select_variables/boxplot_vvol_all_in_one.pdf')
pdf( filename, width=15, height=12, useDingbats=FALSE )
split.screen(c(3,2))
counter = 0
for (variable in variable_names)
{ 
  counter = counter + 1
  screen(counter)
  temp_data_variable_long = vvol_scors_all_pdbs[vvol_scors_all_pdbs$variable == variable,c('pdb','vvol','value')]
  temp_data_variable = reshape(temp_data_variable_long, timevar = 'vvol', idvar = 'pdb', direction = 'wide')
  temp_data_variable = subset (temp_data_variable, select = -c(pdb))
  colnames(temp_data_variable) = levels(vvol_scors_all_pdbs$vvol)
  temp_data_variable = temp_data_variable[vvol_list]
  par( mai=c(0.65, 0.65, 0.1, 0.05), mgp=c(2, 0.5, 0), tck=-0.03 )
  boxplot(temp_data_variable,
          xlab = 'representative Voronoi cell volume (vvol)',
          ylab = paste0('Spearman cor. with ',variable_list[[counter]][1]),
          cex.axis = 1.3,
          cex.lab = 1.3
          )
}
graphics.off()
