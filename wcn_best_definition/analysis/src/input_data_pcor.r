# This code takes in data generated from my Fortran codes that I wrote in search of the best performing definitions of WCN for individual structures compared to the original definitions, while controlling for the distances of sites from the geometrical centers of proteins. This input data will be further used by other R scripts for subsequent analysis.

# Amir Shahmoradi, Monday 4:50 PM, April 20, 2015, Wilke Lab, iCMB, UT Austin

setwd('C:/Users/Amir/Documents/GitHub/cordiv/wcn_best_definition/analysis/src')

# INPUT DATA FOR WCN-Bfactor CORRELATIONS:

  sum_wcneSC_bfSC   = read.table('../../bfactor_partial/sum_wcneSC_bfSC.out',header=T)
  exp_wcneSC_bfSC   = read.table('../../bfactor_partial/exp_wcneSC_bfSC.out',header=F)
  sum_wcnhSC_bfSC   = read.table('../../bfactor_partial/sum_wcnhSC_bfSC.out',header=T)
  exp_wcnhSC_bfSC   = read.table('../../bfactor_partial/exp_wcnhSC_bfSC.out',header=F)
  sum_wcnpSC_bfSC   = read.table('../../bfactor_partial/sum_wcnpSC_bfSC.out',header=T)
  exp_wcnpSC_bfSC   = read.table('../../bfactor_partial/exp_wcnpSC_bfSC.out',header=F)
  sum_wcngSC_bfSC   = read.table('../../bfactor_partial/sum_wcngSC_bfSC.out',header=T)
  exp_wcngSC_bfSC   = read.table('../../bfactor_partial/exp_wcngSC_bfSC.out',header=F)
  #sum_wcneCA_bfCA   = read.table('../../bfactor_partial/sum_wcneCA_bfCA.out',header=T)
  #exp_wcneCA_bfCA   = read.table('../../bfactor_partial/exp_wcneCA_bfCA.out',header=F)
  #sum_wcnhCA_bfCA   = read.table('../../bfactor_partial/sum_wcnhCA_bfCA.out',header=T)
  #exp_wcnhCA_bfCA   = read.table('../../bfactor_partial/exp_wcnhCA_bfCA.out',header=F)
  #sum_wcnpCA_bfCA   = read.table('../../bfactor_partial/sum_wcnpCA_bfCA.out',header=T)
  #exp_wcnpCA_bfCA   = read.table('../../bfactor_partial/exp_wcnpCA_bfCA.out',header=F)
  #sum_wcngCA_bfCA   = read.table('../../bfactor_partial/sum_wcngCA_bfCA.out',header=T)
  #exp_wcngCA_bfCA   = read.table('../../bfactor_partial/exp_wcngCA_bfCA.out',header=F)

# INPUT DATA FOR WCN-r4sJC CORRELATIONS:

  #sum_wcneSC_r4sJC   = read.table('../../r4sJC_partial/sum_wcneSC_r4sJC.out',header=T)
  #exp_wcneSC_r4sJC   = read.table('../../r4sJC_partial/exp_wcneSC_r4sJC.out',header=F)
  #sum_wcnhSC_r4sJC   = read.table('../../r4sJC_partial/sum_wcnhSC_r4sJC.out',header=T)
  #exp_wcnhSC_r4sJC   = read.table('../../r4sJC_partial/exp_wcnhSC_r4sJC.out',header=F)
  #sum_wcnpSC_r4sJC   = read.table('../../r4sJC_partial/sum_wcnpSC_r4sJC.out',header=T)
  #exp_wcnpSC_r4sJC   = read.table('../../r4sJC_partial/exp_wcnpSC_r4sJC.out',header=F)
  #sum_wcngSC_r4sJC   = read.table('../../r4sJC_partial/sum_wcngSC_r4sJC.out',header=T)
  #exp_wcngSC_r4sJC   = read.table('../../r4sJC_partial/exp_wcngSC_r4sJC.out',header=F)
  #sum_wcneCA_r4sJC   = read.table('../../r4sJC_partial/sum_wcneCA_r4sJC.out',header=T)
  #exp_wcneCA_r4sJC   = read.table('../../r4sJC_partial/exp_wcneCA_r4sJC.out',header=F)
  #sum_wcnhCA_r4sJC   = read.table('../../r4sJC_partial/sum_wcnhCA_r4sJC.out',header=T)
  #exp_wcnhCA_r4sJC   = read.table('../../r4sJC_partial/exp_wcnhCA_r4sJC.out',header=F)
  #sum_wcnpCA_r4sJC   = read.table('../../r4sJC_partial/sum_wcnpCA_r4sJC.out',header=T)
  #exp_wcnpCA_r4sJC   = read.table('../../r4sJC_partial/exp_wcnpCA_r4sJC.out',header=F)
  #sum_wcngCA_r4sJC   = read.table('../../r4sJC_partial/sum_wcngCA_r4sJC.out',header=T)
  #exp_wcngCA_r4sJC   = read.table('../../r4sJC_partial/exp_wcngCA_r4sJC.out',header=F)

# INPUT DATA FOR WCN-seqent CORRELATIONS:

  #sum_wcneSC_seqent   = read.table('../../seqent_partial/sum_wcneSC_seqent.out',header=T)
  #exp_wcneSC_seqent   = read.table('../../seqent_partial/exp_wcneSC_seqent.out',header=F)
  #sum_wcnhSC_seqent   = read.table('../../seqent_partial/sum_wcnhSC_seqent.out',header=T)
  #exp_wcnhSC_seqent   = read.table('../../seqent_partial/exp_wcnhSC_seqent.out',header=F)
  #sum_wcnpSC_seqent   = read.table('../../seqent_partial/sum_wcnpSC_seqent.out',header=T)
  #exp_wcnpSC_seqent   = read.table('../../seqent_partial/exp_wcnpSC_seqent.out',header=F)
  #sum_wcngSC_seqent   = read.table('../../seqent_partial/sum_wcngSC_seqent.out',header=T)
  #exp_wcngSC_seqent   = read.table('../../seqent_partial/exp_wcngSC_seqent.out',header=F)
  #sum_wcneCA_seqent   = read.table('../../seqent_partial/sum_wcneCA_seqent.out',header=T)
  #exp_wcneCA_seqent   = read.table('../../seqent_partial/exp_wcneCA_seqent.out',header=F)
  #sum_wcnhCA_seqent   = read.table('../../seqent_partial/sum_wcnhCA_seqent.out',header=T)
  #exp_wcnhCA_seqent   = read.table('../../seqent_partial/exp_wcnhCA_seqent.out',header=F)
  #sum_wcnpCA_seqent   = read.table('../../seqent_partial/sum_wcnpCA_seqent.out',header=T)
  #exp_wcnpCA_seqent   = read.table('../../seqent_partial/exp_wcnpCA_seqent.out',header=F)
  #sum_wcngCA_seqent   = read.table('../../seqent_partial/sum_wcngCA_seqent.out',header=T)
  #exp_wcngCA_seqent   = read.table('../../seqent_partial/exp_wcngCA_seqent.out',header=F)
  
# INPUT DATA FOR WCN-ddgent CORRELATIONS:

  #sum_wcneSC_ddgent   = read.table('../../ddgent_partial/sum_wcneSC_ddgent.out',header=T)
  #exp_wcneSC_ddgent   = read.table('../../ddgent_partial/exp_wcneSC_ddgent.out',header=F)
  #sum_wcnhSC_ddgent   = read.table('../../ddgent_partial/sum_wcnhSC_ddgent.out',header=T)
  #exp_wcnhSC_ddgent   = read.table('../../ddgent_partial/exp_wcnhSC_ddgent.out',header=F)
  #sum_wcnpSC_ddgent   = read.table('../../ddgent_partial/sum_wcnpSC_ddgent.out',header=T)
  #exp_wcnpSC_ddgent   = read.table('../../ddgent_partial/exp_wcnpSC_ddgent.out',header=F)
  #sum_wcngSC_ddgent   = read.table('../../ddgent_partial/sum_wcngSC_ddgent.out',header=T)
  #exp_wcngSC_ddgent   = read.table('../../ddgent_partial/exp_wcngSC_ddgent.out',header=F)
  #sum_wcneCA_ddgent   = read.table('../../ddgent_partial/sum_wcneCA_ddgent.out',header=T)
  #exp_wcneCA_ddgent   = read.table('../../ddgent_partial/exp_wcneCA_ddgent.out',header=F)
  #sum_wcnhCA_ddgent   = read.table('../../ddgent_partial/sum_wcnhCA_ddgent.out',header=T)
  #exp_wcnhCA_ddgent   = read.table('../../ddgent_partial/exp_wcnhCA_ddgent.out',header=F)
  #sum_wcnpCA_ddgent   = read.table('../../ddgent_partial/sum_wcnpCA_ddgent.out',header=T)
  #exp_wcnpCA_ddgent   = read.table('../../ddgent_partial/exp_wcnpCA_ddgent.out',header=F)
  #sum_wcngCA_ddgent   = read.table('../../ddgent_partial/sum_wcngCA_ddgent.out',header=T)
  #exp_wcngCA_ddgent   = read.table('../../ddgent_partial/exp_wcngCA_ddgent.out',header=F)

excluded_pdbs = c('1BBS_A','1BS0_A','1DIN_A','1HPL_A')   # These are the 4 PDBs that did not have complete r4s evolutionary rates and are omitted from the dataset to avoid NA values.

sum_wcneSC_bfSC = sum_wcneSC_bfSC[!(sum_wcneSC_bfSC$pdb %in% excluded_pdbs),]
sum_wcneSC_bfSC$pdb  = factor(sum_wcneSC_bfSC$pdb)
sum_wcneSC_ddgent = sum_wcneSC_ddgent[!(sum_wcneSC_ddgent$pdb %in% excluded_pdbs),]
sum_wcneSC_ddgent$pdb  = factor(sum_wcneSC_ddgent$pdb)
sum_wcneSC_r4sJC = sum_wcneSC_r4sJC[!(sum_wcneSC_r4sJC$pdb %in% excluded_pdbs),]
sum_wcneSC_r4sJC$pdb  = factor(sum_wcneSC_r4sJC$pdb)
sum_wcneSC_distance = sum_wcneSC_distance[!(sum_wcneSC_distance$pdb %in% excluded_pdbs),]
sum_wcneSC_distance$pdb  = factor(sum_wcneSC_distance$pdb)

sum_wcnhSC_bfSC = sum_wcnhSC_bfSC[!(sum_wcnhSC_bfSC$pdb %in% excluded_pdbs),]
sum_wcnhSC_bfSC$pdb  = factor(sum_wcnhSC_bfSC$pdb)
sum_wcnhSC_ddgent = sum_wcnhSC_ddgent[!(sum_wcnhSC_ddgent$pdb %in% excluded_pdbs),]
sum_wcnhSC_ddgent$pdb  = factor(sum_wcnhSC_ddgent$pdb)
sum_wcnhSC_r4sJC = sum_wcnhSC_r4sJC[!(sum_wcnhSC_r4sJC$pdb %in% excluded_pdbs),]
sum_wcnhSC_r4sJC$pdb  = factor(sum_wcnhSC_r4sJC$pdb)
sum_wcnhSC_distance = sum_wcnhSC_distance[!(sum_wcnhSC_distance$pdb %in% excluded_pdbs),]
sum_wcnhSC_distance$pdb  = factor(sum_wcnhSC_distance$pdb)

sum_wcngSC_bfSC = sum_wcngSC_bfSC[!(sum_wcngSC_bfSC$pdb %in% excluded_pdbs),]
sum_wcngSC_bfSC$pdb  = factor(sum_wcngSC_bfSC$pdb)
sum_wcngSC_ddgent = sum_wcngSC_ddgent[!(sum_wcngSC_ddgent$pdb %in% excluded_pdbs),]
sum_wcngSC_ddgent$pdb  = factor(sum_wcngSC_ddgent$pdb)
sum_wcngSC_r4sJC = sum_wcngSC_r4sJC[!(sum_wcngSC_r4sJC$pdb %in% excluded_pdbs),]
sum_wcngSC_r4sJC$pdb  = factor(sum_wcngSC_r4sJC$pdb)
sum_wcngSC_r4sJC$pdb  = factor(sum_wcngSC_r4sJC$pdb)
sum_wcngSC_distance = sum_wcngSC_distance[!(sum_wcngSC_distance$pdb %in% excluded_pdbs),]
sum_wcngSC_distance$pdb  = factor(sum_wcngSC_distance$pdb)

sum_wcnpSC_bfSC = sum_wcnpSC_bfSC[!(sum_wcnpSC_bfSC$pdb %in% excluded_pdbs),]
sum_wcnpSC_bfSC$pdb  = factor(sum_wcnpSC_bfSC$pdb)
sum_wcnpSC_ddgent = sum_wcnpSC_ddgent[!(sum_wcnpSC_ddgent$pdb %in% excluded_pdbs),]
sum_wcnpSC_ddgent$pdb  = factor(sum_wcnpSC_ddgent$pdb)
sum_wcnpSC_r4sJC = sum_wcnpSC_r4sJC[!(sum_wcnpSC_r4sJC$pdb %in% excluded_pdbs),]
sum_wcnpSC_r4sJC$pdb  = factor(sum_wcnpSC_r4sJC$pdb)
sum_wcnpSC_distance = sum_wcnpSC_distance[!(sum_wcnpSC_distance$pdb %in% excluded_pdbs),]
sum_wcnpSC_distance$pdb  = factor(sum_wcnpSC_distance$pdb)


###  plot(test$parameter,abs(test$mean_sp),type='l', col='black', ylim=c(0.,0.9))
###  lines(test$parameter,abs(test$median_sp),col='red')
###  lines(test$parameter,abs(test$quantile05_sp),col='green')
###  lines(test$parameter,abs(test$quantile25_sp),col='green')
###  lines(test$parameter,abs(test$quantile75_sp),col='green')
###  lines(test$parameter,abs(test$quantile95_sp),col='green')

# test = data.frame(quantile5  = quantile(as.matrix(exp_wcnp_bfac[-1,-1])[,1], probs = 0.05)) #['5%'],
#                   median     = quantile(as.matrix(exp_wcnp_bfac[-1,-1])[,1], probs = c(0.05, 0.5, 0.95))['50%'],
#                   quantile95 = quantile(as.matrix(exp_wcnp_bfac[-1,-1])[,1], probs = c(0.05, 0.5, 0.95))['95%']
#                   )
# 
#wcnp            = data.frame(parameter      = as.vector(t(exp_wcnp_bfac[1,-1])),
#                             mean_sp   = colMeans(exp_wcnp_bfac[-1,-1]),
#                             median_sp = colMedians(as.matrix(exp_wcnp_bfac[-1,-1]))
#                             )