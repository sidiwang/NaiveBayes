#include <Rcpp.h>


using namespace Rcpp;



// [[Rcpp::export]]
List mean_sd(DataFrame x, CharacterVector y, double laplace = 0){

  int n_var = x.ncol();
  List m_s (x.ncol());
  int n_y = unique(y).size();
  CharacterVector level = unique(y);
  LogicalVector lc (x.nrow());

  for(int j = 0; j < n_var; j++){
    RObject column = x[j];
    Function isnumeric( "is.numeric" );
    LogicalVector judge = isnumeric(column);

    if(judge[0] == TRUE){

      NumericMatrix group (n_y, 2);
      for(int i = 0; i < n_y; i++){
        for(int k = 0; k < x.nrow(); k++){
          lc(k) = (y(k) == level(i));
        }

        NumericVector selected = x[j];
        NumericVector m = selected[lc];
        group(i,_) = NumericVector::create(mean(m), sd(m));
        rownames(group) = level;
        m_s[j] = group;
      }
    } else {

    Function table( "table" );
    CharacterVector selected = x[j];
    DataFrame grouping = table(selected);
    NumericVector Frequen = grouping["Freq"];
    CharacterVector nameofcol = grouping.names();
    String nameofx = nameofcol[0];
    CharacterVector groupnam = grouping[nameofx];
    int group_column = Frequen.size();
    NumericMatrix group (n_y,group_column);
    rownames(group) = level;
    colnames(group) = groupnam;

    for(int i = 0; i < n_y; i++){
      for(int k = 0; k < x.nrow(); k++){
        lc(k) = (y(k) == level(i));
      }
      CharacterVector m = selected[lc];
      DataFrame counts = table(m);
      NumericVector countss = counts["Freq"];
      CharacterVector nameofcol_1 = counts.names();
      String nameofx_1 = nameofcol_1[0];
      CharacterVector xnames = counts[nameofx_1];
      countss.names() = xnames;
      NumericVector rows (group_column);
      rows.names() = groupnam;

      for(CharacterVector::iterator q = groupnam.begin() ; q != groupnam.end(); q++){
        String ind = *q;
        if (std::find(xnames.begin(), xnames.end(),ind)!=xnames.end()){
          rows[ind] = (countss[ind] + laplace)/(m.size() + laplace * group_column);
        } else {
        }
      }
      group(i,_) = rows;
    }

    DataFrame xnamesa = table(selected);
    CharacterVector nameofcol_2 = xnamesa.names();
    String nameofx_2 = nameofcol_2[0];
    CharacterVector xnam = xnamesa[nameofx_2];

    colnames(group) = xnam;
    m_s[j] = group;
  }
  }
  return m_s;
}











