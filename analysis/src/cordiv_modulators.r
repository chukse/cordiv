# This R scripts generates a plot of the most influential pdb-level variables on the structure-sequence correlations.


index = names(result) %in% c("r.rsa_avg_md", "r.wcn_avg_md", "r.chi1_var_md", "r.rmsf_avg_md", "r.bfca") #, "avg_cr_rho") # columns we want to plot
index.p = names(result) %in% c("p.rsa_avg_md", "p.wcn_avg_md", "p.chi1_var_md", "p.rmsf_avg_md", "p.bfca") # columns that store significance

colors = c('red', 'blue', 'green', 'purple', 'orange3', 'darkgreen', 'black', 'gray', 'cyan2') #, 'darkred', 'darkgreen', 'bisque2')
###proteins = c('1RD8_AB', '2FP7_B', '2JLY_A', '2Z83_A', '3GOL_A', '3LYF_A', '4AQF_B', '4GHA_A', '4IRY_A') #, '3GSZ_A', '3I5K_A', '2JLY_A_temp_50', '2JLY_A_temp_100', '2JLY_A_temp_200', '2JLY_A_temp_450')
proteins = c('1RD8_AB', '2FP7_B', '2Z83_A', '3LYF_A', '4AQF_B', '4GHA_A', '4IRY_A') #, '3GSZ_A', '3I5K_A', '2JLY_A_temp_50', '2JLY_A_temp_100', '2JLY_A_temp_200', '2JLY_A_temp_450')
###labels = c('1RD8', '2FP7', '2JLY', '2Z83', '3GOL', '3LYF', '4AQF', '4GHA', '4IRY') #, '3GSZ_A', '3I5K_A', '2JLY_A_temp_50', '2JLY_A_temp_100', '2JLY_A_temp_200', '2JLY_A_temp_450')
labels = c('1RD8', '2FP7', '2Z83', '3LYF', '4AQF', '4GHA', '4IRY') #, '3GSZ_A', '3I5K_A', '2JLY_A_temp_50', '2JLY_A_temp_100', '2JLY_A_temp_200', '2JLY_A_temp_450')

pdf( "correlation_analysis/figures/cor_r4s_all.pdf", width=7, height=4, useDingbats=FALSE )
par( mai=c(0.65, 0.65, 0.0, 0.05), mgp=c(2, 0.5, 0), tck=-0.03 )
plot(0,xaxt='n',yaxt='n',bty='n',pch='',ylab=expression(paste("Correlation (", rho, ") with r4s")),xlab='Correlating Variable', xlim=c(1,5.2),ylim=c(-.5,.45)) #, main = 'sequence r4s - contact number association', cex.main=0.8)
#minor.tick(nx=0, ny=4, tick.ratio=2)
axis( 2,  # y axis
	  at=c(-.4,-.3,-.2,-.1,0,.1,.2,.3,.4),
	  c("-0.4","","-0.2","","0.0","","0.2","","0.4"))
axis( 1,
      at=c(1, 2, 3, 4, 5),
      padj=c(0,0,0,0,0,0),
      c("MD RSA", "MD iWCN", expression(paste("MD Var(", chi[1],")")), "MD RMSF", "B factor")) #,  "CS rmsf"))


for( i in 1:nrow(result) )
{
	if ( i <= length(proteins) )
	{
		if ( result$protein[i] == proteins[i] )
		{
			row = unlist( result[i,index] )
			x = 1:sum(index)
			print( i )
			lines( x, row, col=colors[i] )
			p = unlist( result[i,index.p] )
			sign = p < 0.05
			print(row)
			print(p)
			print(sign)
			points( x[sign], row[sign], pch=19, col=colors[i])
			points( x[!sign], row[!sign], pch=1, col=colors[i])
		}
		else
		{
			cat( "Error: data mismatch!\n" ) 
		}
	}
	else
	{
		cat( "skipping ", as.character(result$protein[i]), "\n" ) 
	}
}

legend( 1.0, -.28, labels[1:3], pch=19, col=colors[1:3], bty='n', cex=0.9)
legend( 1.7, -.28, labels[4:6], pch=19, col=colors[4:6], bty='n', cex=0.9)
legend( 2.4, -.28, labels[7], pch=19, col=colors[7], bty='n', cex=0.9)
dev.off()